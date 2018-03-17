import Foundation
import UIKit

typealias RecipiesViewModelType = RecipiesViewModelProtocol & UITableViewDelegate & UITableViewDataSource

protocol RecipiesViewModelProtocol {
    
}

class RecipiesViewModel: NSObject, RecipiesViewModelType {
    
    var recipies: [RecipeGeneral] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        //
//        cell.configureCell()
        return cell
    }
    
}
