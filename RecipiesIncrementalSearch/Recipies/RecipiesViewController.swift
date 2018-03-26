import Foundation
import UIKit
import RxSwift
import RxCocoa
import Dwifft

class RecipiesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var searchBar: UISearchBar = {
        return UISearchBar()
    }()
    
    lazy var errorViewController: ErrorViewController = {
        return ErrorViewController()
    }()
    
    private let disposeBag = DisposeBag()
    var viewModel: RecipiesViewModelType!
    
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
        let searchObservable =
        searchBar.rx.text
            .orEmpty
            .skip(1)
            .debounce(0.5, scheduler: SerialDispatchQueueScheduler.init(qos: .userInitiated))
            .flatMapLatest(fetchGeneralRecipies)
        
        searchObservable
            .debug()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] event in
                guard let safeSelf = self else { return }
                switch event {
                case .next(let fetchedRecipies):
                    safeSelf.errorViewController.remove()
                    safeSelf.render(recipies: fetchedRecipies)
                    safeSelf.tableView.alpha = 1.0
                    safeSelf.stopActivityIndicator()
                case .error(_):
                    safeSelf.add(safeSelf.errorViewController)
                    safeSelf.prepareErrorController()
                    safeSelf.tableView.alpha = 0.0
                    safeSelf.stopActivityIndicator()
                case .completed:
                    return
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func prepareErrorController() {
        errorViewController.view.translatesAutoresizingMaskIntoConstraints = false
        errorViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        errorViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func fetchGeneralRecipies(for searchQuery: String) -> Observable<Event<[RecipeGeneral]>> {
        self.startActivityIndicator()
        return viewModel.fetchGeneralRecipies(for: searchQuery)
            .observeOn(MainScheduler.instance)
            .do(onNext: {[weak self] (fetchedRecipies) in
                self?.stopActivityIndicator()
            })
            .materialize()
        
    }
    
    private func render(recipies: [RecipeGeneral]) {
        viewModel.recipies = recipies
        updateRecipies(currentRecipies: viewModel.recipies, previousRecipies: recipies)
        tableView.reloadData()
    }
    
    private func updateRecipies(currentRecipies:[RecipeGeneral], previousRecipies: [RecipeGeneral]) {
        /*let (deletedIndexPaths, insertedIndexPaths) = currentRecipies.diffIndexs(previousRecipies)
        if #available(iOS 11.0, *) {
            self.tableView.performBatchUpdates({ () -> Void in
                self.tableView.deleteItemsAtIndexPaths(deletedIndexPaths)
                self.tableView.insertItemsAtIndexPaths(insertedIndexPaths)
            }, completion: nil)
        } else {
            return
        }
         */
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

