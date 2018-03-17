import Foundation
import UIKit

class RecipiesCoordinator: Coordinator {
    
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
        window.rootViewController = recipiesNavigationViewController
    }
}
