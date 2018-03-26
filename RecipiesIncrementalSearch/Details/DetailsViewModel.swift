import Foundation
import RxSwift
import UIKit

typealias DetailsViewModelType = BaseViewModelProtocol & DetailsViewModelProtocol & UITableViewDelegate & UITableViewDataSource

protocol DetailsViewModelProtocol {
    func fetchRecipeDetails() -> Observable<RecipeDetails>
    var recipeDetails: RecipeDetails? { get set }
}

class DetailsViewModel: NSObject, DetailsViewModelType {
    
    let apiClient: APIClientType
    var recipeDetails: RecipeDetails?
    let recipeID: Int
    
    var errorMessage: PublishSubject<String?> = PublishSubject()
    
    weak var coordinatorDelegate: DetailsCoordinatorDelegate?
    
    init(apiClient: APIClientType, recipeID: Int) {
        self.apiClient = apiClient
        self.recipeID = recipeID
    }
    
    //MARK: Network requests
    func fetchRecipeDetails() -> Observable<RecipeDetails> {
        return apiClient.fetchRecipeDetails(for: recipeID).do(onError: { [weak self] (error) in
            self?.errorMessage.onNext(error.localizedDescription)
        })
    }
    
}

extension DetailsViewModel {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell", for: indexPath) as! DescriptionCell
            cell.configureWith(descriptionText: recipeDetails?.description ?? "")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
            cell.configureCell(with: recipeDetails?.numberOfLikes ?? 0)
            cell.didSelectButton = { [weak self] in
                self?.coordinatorDelegate?.showWebView(for: self?.recipeDetails?.id ?? 0)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return UITableViewAutomaticDimension
        } else if indexPath.section == 2 {
            return 100
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 250
        } else {
            return 150
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return nil
        }
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DetailsHeader") as! DetailsHeader
        if let recipeDetails = recipeDetails, let imageURL = recipeDetails.imageURL {
            apiClient.fetchImage(for: imageURL)
                .asDriver(onErrorJustReturn: UIImage.godtPlaceholder)
                .drive(onNext: { (fetchedImage) in
                    headerView.foodImageView.image = fetchedImage
                }).disposed(by: headerView.disposeBag)
        } else {
            headerView.foodImageView.image = UIImage.godtPlaceholder
        }
        
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else {
            return 44
        }
        
        return 250
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section != 0 else {
            return nil
        }
        return section == 1 ? "Description" : "Info"
    }
    
}


