import Foundation
import UIKit

protocol Coordinator: class {
    func start()
}

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    lazy var apiClient: APIClientType = APIClient()
    var recipiesCoordinator: RecipiesCoordinator!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showRecipies()
    }
}

extension AppCoordinator {
    fileprivate func showRecipies() {
        recipiesCoordinator = RecipiesCoordinator(window: window, apiClient: apiClient)
        recipiesCoordinator.start()
    }
}
