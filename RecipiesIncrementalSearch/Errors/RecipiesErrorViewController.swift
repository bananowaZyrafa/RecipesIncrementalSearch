import Foundation
import UIKit

class RecipiesErrorViewController: UIViewController {
    
    var reloadHandler: () -> Void = {}
    
    lazy var errorLabel: UILabel = {
        return UILabel()
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareErrorLabel()
    }
    
    func prepareErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Results not found"
        errorLabel.textAlignment = .center
        errorLabel.textColor = .lightGray
    }
    
}

