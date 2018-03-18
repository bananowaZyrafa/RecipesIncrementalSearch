import Foundation
import UIKit
import RxSwift

class DetailsHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
}
