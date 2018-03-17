import Foundation
import UIKit

class RecipiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var searchBar: UISearchBar = {
        return UISearchBar()
    }()
    
    
    var viewModel: RecipiesViewModelType! {
        didSet {
            bindViewModel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchBar()
        prepareTableView()
    }
    
    func prepareTableView() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.register(RecipeCell.self, forCellReuseIdentifier: RecipeCell.reuseIdentifier)
    }
    
    func bindViewModel() {
        
    }
    
}


private typealias PrepareView = RecipiesViewController
extension PrepareView {
    
    private func prepareSearchBar() {
        searchBar.placeholder = "Search for recipe..."
        searchBar.sizeToFit()
        
        if #available(iOS 11.0, *) {
            embedSearchBarInNavigationBar()
        } else {
            embedSearchOverTableView()
        }
        
    }
    
    private func embedSearchBarInNavigationBar() {
        navigationItem.titleView = searchBar
    }
    
    private func embedSearchOverTableView() {
        searchBar.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        stackView.insertArrangedSubview(searchBar, at: 0)
    }
}

