import Foundation
import RxSwift

protocol BaseViewModelProtocol: class {
    var errorMessage: PublishSubject<String?> { get set }
}
