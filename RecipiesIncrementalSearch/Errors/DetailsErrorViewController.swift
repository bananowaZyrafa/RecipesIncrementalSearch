import Foundation
import UIKit

class DetailsErrorViewController: UIViewController {
    
    var reloadHandler: () -> Void = {}
    
    lazy var errorButton: UIButton = {
        return UIButton()
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
        view.addSubview(errorButton)
        errorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        errorButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        errorButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        errorButton.translatesAutoresizingMaskIntoConstraints = false
        errorButton.setTitle("Details could not be loaded. Press to reload.", for: .normal)
        errorButton.setTitleColor(.lightGray, for: .normal)
        errorButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
    }
    
    @objc func reload() {
        reloadHandler()
    }
    
}

