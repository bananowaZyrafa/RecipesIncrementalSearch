import Foundation
import UIKit

class DetailsCoordinator: Coordinator {
    
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
        guard let vc = ViewControllerFactory.details.viewController() as? DetailsViewController else {
            fatalError("Error when instatiating Details view controller")
        }
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
