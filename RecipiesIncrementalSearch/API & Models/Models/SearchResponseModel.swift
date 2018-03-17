import Foundation

struct SearchResponseModel: Decodable {
    let count: Int
    let results: [RecipeGeneral]
    
    enum CodingKeys: String, CodingKey {
        case count
        case results
    }
}
