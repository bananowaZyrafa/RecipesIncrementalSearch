import Foundation
import UIKit

enum ViewControllerFactory {
    case recipies
    case details
}

extension ViewControllerFactory {
    func viewController() -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch self {
        case .recipies:
            guard let nc = storyboard.instantiateViewController(withIdentifier: "RecipiesNavigationController")
                as? UINavigationController
                else {
                    fatalError("Recipies navigation controller instatiating error")
            }
            return nc
            
        case .details:
            guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else {
                fatalError("Details view controller instatiating error")
            }
            return vc
        }
    }
}
