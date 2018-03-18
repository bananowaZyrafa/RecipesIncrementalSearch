import Foundation
import RxSwift
import UIKit

typealias DetailsViewModelType = DetailsViewModelProtocol & UITableViewDelegate & UITableViewDataSource

protocol DetailsViewModelProtocol {
    func fetchRecipeDetails(for recipeID: Int) -> Observable<RecipeDetails>
}

class DetailsViewModel: NSObject, DetailsViewModelType {
    
    let apiClient: APIClientType
    var recipeDetails: RecipeDetails?
    let recipeID: Int
    
    init(apiClient: APIClientType, recipeID: Int) {
        self.apiClient = apiClient
        self.recipeID = recipeID
    }
    
    //MARK: Network requests
    func fetchRecipeDetails(for recipeID: Int) -> Observable<RecipeDetails> {
        return apiClient.fetchRecipeDetails(for: recipeID)
    }
    
}

extension DetailsViewModel {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

