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
            .debounce(0.5, scheduler: ConcurrentDispatchQueueScheduler.init(qos: .userInitiated))
            .flatMapLatest(fetchGeneralRecipies)
            .share()
            
        Observable.zip(searchObservable, searchObservable.startWith(viewModel.recipies))
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: {[weak self] (currentRecipies, previousRecipies) -> Void in
                self?.updateRecipies(currentRecipies: currentRecipies, previousRecipies: previousRecipies)
            }).disposed(by: disposeBag)
        
    }
    
    func fetchGeneralRecipies(for searchQuery: String) -> Observable<[RecipeGeneral]> {
        self.startActivityIndicator()
        return viewModel.fetchGeneralRecipies(for: searchQuery)
            .observeOn(MainScheduler.instance)
            .do(onNext: {[weak self] (fetchedRecipies) in
                self?.render(recipies: fetchedRecipies)
                self?.stopActivityIndicator()
                },onError:{ [weak self] error in
                    self?.presentError(error: error)
            })
            .catchError({[weak self] (error) -> Observable<[RecipeGeneral]> in
                print(error)
                self?.presentError(error: error)
                return Observable.just([])
            })
        
    }
    
    
    private func render(recipies: [RecipeGeneral]) {
        viewModel.recipies = recipies
        tableView.reloadData()
    }
    
    func presentError(error: Error) {
        let alert = UIAlertController(title: "OOOPS", message: "Error occured", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(alertAction)
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
        
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

extension RecipiesViewController {
    func startActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
    }
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
}

