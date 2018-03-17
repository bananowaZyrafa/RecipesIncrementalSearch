import Foundation
import UIKit

class RecipeCell: UITableViewCell {
    
    static let reuseIdentifier = "RecipeCell"
    
    @IBOutlet weak var reipceImage: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        //dispose
    }
    
}
