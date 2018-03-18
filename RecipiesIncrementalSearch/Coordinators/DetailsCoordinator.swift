import Foundation
import UIKit
import SafariServices

protocol DetailsCoordinatorDelegate: class {
    func showWebView(for recipeID: Int)
}

class DetailsCoordinator: Coordinator, DetailsCoordinatorDelegate {
    
    let apiClient: APIClientType
    let recipeID: Int
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController, apiClient: APIClientType, recipeID: Int) {
        self.navigationController = navigationController
        self.apiClient = apiClient
        self.recipeID = recipeID
    }
    
    func start() {
        let viewModel = DetailsViewModel(apiClient: apiClient, recipeID: recipeID)
        viewModel.coordinatorDelegate = self
        guard let vc = ViewControllerFactory.details.viewController() as? DetailsViewController else {
            fatalError("Error when instatiating Details view controller")
        }
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func showWebView(for recipeID: Int) {
        let recipeURLString = APIClient.EndpointURL.webview
        guard let recipeURL = URL(string: recipeURLString.appending("\(recipeID)")) else {
            return
        }
        let safariVC = SFSafariViewController(url: recipeURL)
        navigationController.present(safariVC, animated: true, completion: nil)
    }
}
