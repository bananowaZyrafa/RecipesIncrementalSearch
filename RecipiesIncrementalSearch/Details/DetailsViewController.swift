import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: DetailsViewModelType!
    private let disposeBag = DisposeBag()
    
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
                })
            .disposed(by: disposeBag)
    }
    
    private func render(details: RecipeDetails) {
        title = details.title
        viewModel.recipeDetails = details
        tableView.reloadData()
        tableView.isHidden = false
    }
    
}

