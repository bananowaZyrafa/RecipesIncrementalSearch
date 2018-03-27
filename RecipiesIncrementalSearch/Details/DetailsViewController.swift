import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: DetailsViewModelType!
    private let disposeBag = DisposeBag()
    
    lazy var errorViewController: DetailsErrorViewController = {
        return DetailsErrorViewController()
    }()
    
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
        startActivityIndicator()
        viewModel.fetchRecipeDetails()
            .observeOn(MainScheduler.instance)
            .materialize()
            .subscribe(onNext: { [weak self] event in
                guard let safeSelf = self else { return }
                switch event {
                case .next(let fetchedDetails):
                    safeSelf.errorViewController.remove()
                    safeSelf.render(details: fetchedDetails)
                    safeSelf.tableView.alpha = 1.0
                    safeSelf.tableView.isUserInteractionEnabled = true
                    safeSelf.stopActivityIndicator()
                case .error(_):
                    safeSelf.handleError()
                    safeSelf.prepareErrorController()
                    safeSelf.tableView.alpha = 0.0
                    safeSelf.tableView.isUserInteractionEnabled = false
                    safeSelf.stopActivityIndicator()
                case .completed:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func render(details: RecipeDetails) {
        title = details.title
        viewModel.recipeDetails = details
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    private func handleError() {
        errorViewController.reloadHandler = { [weak self] in
            self?.bindViewModel()
        }
        add(errorViewController)
    }
    
    private func prepareErrorController() {
        errorViewController.view.translatesAutoresizingMaskIntoConstraints = false
        errorViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        errorViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        errorViewController.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        errorViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

