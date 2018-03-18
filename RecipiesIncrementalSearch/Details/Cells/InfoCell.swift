import UIKit

class InfoCell: UITableViewCell {

    @IBAction func viewOriginal(_ sender: Any) {
        didSelectButton()
    }
    
    @IBOutlet weak var likesLabel: UILabel!
    
    var didSelectButton: () -> Void = {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(with likesNumber: Int) {
        likesLabel.text = "\(likesNumber)"
    }

}
