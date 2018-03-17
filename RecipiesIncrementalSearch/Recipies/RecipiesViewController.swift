import Foundation
import UIKit

class RecipiesViewController: UIViewController {
    
    var viewModel: RecipiesViewModelType! {
        didSet {
            bindViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        
    }
    
}
