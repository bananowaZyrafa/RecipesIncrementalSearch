import Foundation
import UIKit
import RxSwift
import RxCocoa

class DetailsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var viewModel: DetailsViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    func prepareTableView() {
//        tableView.delegate = viewModel
//        tableView.dataSource = viewModel
    }
    
    func bindViewModel() {
        
    }
    
}
