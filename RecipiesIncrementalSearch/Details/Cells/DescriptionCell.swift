import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var descriptionText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWith(descriptionText: String) {
        self.descriptionText.text = descriptionText
    }

}
