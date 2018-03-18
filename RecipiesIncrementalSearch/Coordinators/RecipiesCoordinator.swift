import Foundation
import UIKit

protocol RecipiesCordinatorDelegate: class {
    func didSelectRecipe(with id: Int)
}

class RecipiesCoordinator: Coordinator, RecipiesCordinatorDelegate {
    
    let window: UIWindow
    let apiClient: APIClientType
    
    init(window: UIWindow, apiClient: APIClientType) {
        self.window = window
        self.apiClient = apiClient
    }
    
    func start() {
        let viewModel = RecipiesViewModel(apiClient: apiClient)
        guard let recipiesNavigationViewController = ViewControllerFactory.recipies.viewController()
            as? UINavigationController else {
                fatalError("Wrong vc setup")
        }
        guard let vc = recipiesNavigationViewController.topViewController as? RecipiesViewController else {
            fatalError("Wrong storyboard setup")
        }
        vc.viewModel = viewModel
        viewModel.coordinatorDelegate = self
        window.rootViewController = recipiesNavigationViewController
    }
    
    func didSelectRecipe(with id: Int)  {
        guard let recipiesNavigationViewController = window.rootViewController
            as? UINavigationController else {
                fatalError("Wrong vc setup")
        }
        let detailsCoordinator = DetailsCoordinator(navigationController: recipiesNavigationViewController, apiClient: apiClient, recipeID: id)
        detailsCoordinator.start()
    }
}
