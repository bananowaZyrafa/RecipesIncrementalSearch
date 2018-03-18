import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: DetailsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        prepareTableView()
        tableView.isHidden = true
    }
    
    func prepareTableView() {
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.register(UINib(nibName: "DetailsHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "DetailsHeader")
    }
    
    func bindViewModel() {
        viewModel.fetchRecipeDetails()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {[weak self] fetchedRecipies in
                self?.render(details: fetchedRecipies)
                self?.stopActivityIndicator()
                }, onError:{ [weak self] error in
                    self?.presentError(error: error)
            }).disposed(by: disposeBag)
    }
    
    private func render(details: RecipeDetails) {
        title = details.title
        viewModel.recipeDetails = details
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    func presentError(error: Error) {
        
    }
}

extension DetailsViewController {
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

