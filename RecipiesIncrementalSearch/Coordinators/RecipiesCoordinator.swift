import Foundation
import UIKit

class RecipiesCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewModel = RecipiesViewModel()
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
