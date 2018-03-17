import Foundation

struct RecipeGeneral: Decodable {
    let id: Int
    let title: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image"
    }
}
