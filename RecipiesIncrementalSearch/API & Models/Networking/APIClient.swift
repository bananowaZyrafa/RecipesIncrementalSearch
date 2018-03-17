import Foundation
import RxSwift

protocol APIClientType {
    func fetchGeneralRecipies(for searchQuery: String) -> Observable<[RecipeGeneral]>
    func fetchImage(for imageURL: String) -> Observable<UIImage>
//    func fetchDetailedRecipies(for identifier: Int) -> Observable<
    
}

class APIClient: APIClientType {

    private let urlSession: URLSession
    
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    private struct EndpointURL {
        static let search = "https://www.godt.no/api/search/recipes"
        static let details = "https://www.godt.no/api/recipes/"
        static let webview = "https://www.godt.no/#!/oppskrift/"
    }
    
    enum APIError: Error {
        case invalidURL
        case parsingError
        case imageDataError
        case invalidResponseType
        case JSONSerializationError
        case invalidDataReceived
        case unknownError
        case invalidSelf
    }
    
    
    func fetchGeneralRecipies(for searchQuery: String) -> Observable<[RecipeGeneral]> {
        let params = ["query" : searchQuery,
                    "limit" : "50"
                    ]
        return fetchData(urlString: EndpointURL.search, params: params)
            .flatMap{ [weak self] data -> Observable<SearchResponseModel> in
                return self?.parseObservable(data: data) ?? .just(SearchResponseModel.emptyResponse)
            }
            .map{$0.results}
    }
    
    func fetchImage(for imageURL: String) -> Observable<UIImage> {
        return fetchData(urlString: imageURL)
            .flatMap { data -> Observable<UIImage> in
                let image = UIImage(data: data) ?? UIImage.godtPlaceholder
                return Observable.just(image)
            }
        
    }
    
    private func fetchData(urlString: String, params: [String: String] = [:]) -> Observable<Data> {
        return Observable.create{ [weak self] observer in
            guard let url = URL(string: urlString) else {
                    observer.onError(APIError.invalidURL)
                    return Disposables.create()
            }
            let queryItems = params.map { parameter in
                URLQueryItem(name: parameter.key, value: parameter.value)
            }
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            if queryItems.count > 0 {
                urlComponents.queryItems = queryItems
            }
            guard let urlWithQueryItems = urlComponents.url else {
                observer.onError(APIError.invalidURL)
                return Disposables.create()
            }
            let request = URLRequest(url: urlWithQueryItems)
            
            guard let `self` = self else {
                observer.onError(APIError.invalidSelf)
                return Disposables.create()
            }
            
            let task = self.urlSession.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    observer.onError(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    observer.onError(APIError.invalidResponseType)
                    return
                }
                guard let data = data else {
                    observer.onError(APIError.invalidDataReceived)
                    return
                }
                observer.onNext(data)
                observer.onCompleted()
                
            })
            task.resume()
            return Disposables.create {
                if let _ = task.response {
                    print("request completed")
                } else {
                    task.cancel()
                    print("request cancelled")
                }
            }
        }
    }
    
    
    private func parseObservable<T: Decodable>(data: Data) -> Observable<T> {
        return Observable.create { observer in
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                observer.onNext(decodedData)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    
}






