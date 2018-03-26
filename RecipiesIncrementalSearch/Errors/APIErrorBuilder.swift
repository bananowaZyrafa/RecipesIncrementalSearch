import Foundation

enum APIError: Error {
    case invalidURL
    case parsingError
    case imageDataError
    case invalidResponseType
    case JSONSerializationError
    case invalidDataReceived
    case unknownError
    case invalidSelf
    case networkConnectionProblem
}

class APIErrorBuilder {
    class func errorMessage(for error: APIError) -> String {
        var errorMessage = ""
        switch error {
        case .invalidURL:
            errorMessage = "Provided URL is not valid"
        case .parsingError:
            errorMessage = "Problem occured when parsing server response"
        case .imageDataError:
            errorMessage = "Couldn't read image data"
        case .invalidResponseType:
            errorMessage = "Invalid server response type"
        case .JSONSerializationError:
            errorMessage = "Could not serialize JSON response"
        case .invalidDataReceived:
            errorMessage = "Invalid data received from server"
        case .unknownError:
            errorMessage = "Unknown error"
        case .invalidSelf:
            errorMessage = "Object self dealocated"
        case .networkConnectionProblem:
            errorMessage = "Internet connectivity is off"
        }
        return errorMessage
    }
    
    class func errorMessage(for error: Error) -> String {
        return error.localizedDescription
    }
}
