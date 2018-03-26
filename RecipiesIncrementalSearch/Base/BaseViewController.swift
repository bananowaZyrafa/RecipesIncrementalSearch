import Foundation
import RxSwift
import UIKit

class BaseViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var errorMessage: PublishSubject<String?> = PublishSubject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindErrorPresenting()
    }
    
    func bindErrorPresenting() {
            errorMessage
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](errorMessage) in
                guard let safeSelf = self, let errorMessage = errorMessage else  { return }
                safeSelf.presentErrorAlert(for: errorMessage)
            }).disposed(by: disposeBag)
    }
    
    func presentErrorAlert(for errorDescription: String) {
        let alertController = UIAlertController(title: "OOPs", message: errorDescription, preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
    }
    
}
