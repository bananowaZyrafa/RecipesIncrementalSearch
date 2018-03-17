import Foundation
import UIKit

protocol Coordinator: class {
    func start()
}

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showRecipies()
    }
}

extension AppCoordinator {
    fileprivate func showRecipies() {
        let recipiesCoordinator = RecipiesCoordinator(window: window)
        recipiesCoordinator.start()
    }
}
