import Foundation
import UIKit
import RxSwift
import RxCocoa

class RecipiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var searchBar: UISearchBar = {
        return UISearchBar()
    }()
    
    private let disposeBag = DisposeBag()
    
    var viewModel: RecipiesViewModelType!
//        didSet {
//            bindViewModel()
//        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchBar()
        prepareTableView()
        bindViewModel()
    }
    
    func prepareTableView() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    func bindViewModel() {
        viewModel.fetchGeneralRecipies(for: "cake")
            .catchError({ (error) -> Observable<[RecipeGeneral]> in
                print(error)
                return Observable.just([])
            })
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: {[weak self] fetchedRecipies in
                self?.render(recipies: fetchedRecipies)
            })
            .disposed(by: disposeBag)
    }
    
    private func render(recipies: [RecipeGeneral]) {
        viewModel.recipies = recipies
        tableView.reloadData()
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

