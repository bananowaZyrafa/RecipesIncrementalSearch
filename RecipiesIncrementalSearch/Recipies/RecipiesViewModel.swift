import Foundation
import RxSwift
import UIKit

typealias RecipiesViewModelType = RecipiesViewModelProtocol & UITableViewDelegate & UITableViewDataSource

protocol RecipiesViewModelProtocol {
    var recipies: [RecipeGeneral]  { get set }
    func fetchGeneralRecipies(for searchQuery: String) -> Observable<[RecipeGeneral]>
}

class RecipiesViewModel: NSObject, RecipiesViewModelType {
    
    let apiClient: APIClientType
    var recipies: [RecipeGeneral] = []
    weak var delegate: RecipiesCordinatorDelegate?
    
    init(apiClient: APIClientType) {
        self.apiClient = apiClient
    }

    //MARK: Network requests
    func fetchGeneralRecipies(for searchQuery: String) -> Observable<[RecipeGeneral]> {
        guard searchQuery.count > 0 else {
            return .just([])
        }
        return apiClient.fetchGeneralRecipies(for: searchQuery).catchErrorJustReturn([])
    }
    
    
}

extension RecipiesViewModel {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as? RecipeCell else {
            return UITableViewCell()
        }
        let currentRecipe = recipies[indexPath.row]
        apiClient.fetchImage(for: currentRecipe.imageURL)
            .asDriver(onErrorJustReturn: UIImage.godtPlaceholder)
            .drive(onNext: { (fetchedImage) in
                cell.configure(with: fetchedImage)
            }).disposed(by: cell.disposeBag)
        
        cell.configure(with: currentRecipe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let viewModel = DetailsViewModel(apiClient: apiClient, recipeID: recipies[indexPath.row].id)
//        guard let vc = ViewControllerFactory.details.viewController() as? DetailsViewController else {
//            fatalError("Error when instatiating Details view controller")
//        }
//        vc.viewModel = viewModel
//        guard let recipiesNavigationViewController = ViewControllerFactory.recipies.viewController()
//            as? UINavigationController else {
//                fatalError("Wrong vc setup")
//        }
//        recipiesNavigationViewController.pushViewController(vc, animated: true)
        
        delegate?.didSelectRecipe(with: recipies[indexPath.row].id)
    }

}
