import Foundation
import UIKit
import RxSwift

class RecipeCell: UITableViewCell {
    
    static let reuseIdentifier = "RecipeCell"
    
    var disposeBag = DisposeBag()
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func configure(with recipe: RecipeGeneral) {
        recipeTitle.text = recipe.title
    }
    
    func configure(with image: UIImage) {
        recipeImage.image = image
    }
}
