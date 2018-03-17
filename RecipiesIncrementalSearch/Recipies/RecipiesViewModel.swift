import Foundation
import RxSwift
import UIKit

typealias RecipiesViewModelType = RecipiesViewModelProtocol & UITableViewDelegate & UITableViewDataSource

protocol RecipiesViewModelProtocol {
    var recipies: [RecipeGeneral]  { get set }
    func fetchGeneralRecipies(for searchQuery: String) -> Observable<[RecipeGeneral]>
}

class RecipiesViewModel: NSObject, RecipiesViewModelType {
    
    let apiClient: APIClientType
    var recipies: [RecipeGeneral] = []
    
    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }

    //MARK: Network requests
    func fetchGeneralRecipies(for searchQuery: String) -> Observable<[RecipeGeneral]> {
        return apiClient.fetchGeneralRecipies(for: searchQuery)
    }
    
    
}

extension RecipiesViewModel {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        let currentRecipe = recipies[indexPath.row]
        apiClient.fetchImage(for: currentRecipe.imageURL)
            .debug()
            .asDriver(onErrorJustReturn: UIImage.godtPlaceholder)
            .drive(onNext: { (fetchedImage) in
                cell.configure(with: fetchedImage)
            }).disposed(by: cell.disposeBag)
        
        cell.configure(with: currentRecipe)
        
        return cell
    }

}
