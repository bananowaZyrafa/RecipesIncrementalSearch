import Foundation

struct RecipeDetails: Decodable {
    let title: String
    let numberOfLikes: Int
    let description: String
    let id: Int
    let imageURLs: [ImageURL]
    var imageURL: String? {
        return imageURLs.first?.url
    }
    
    static let emptyResponse = RecipeDetails(title: "", id: 0, numberOfLikes: 0, description: "", imageURLs: [])
    
    enum CodingKeys: String, CodingKey {
        case title
        case numberOfLikes
        case description
        case id
        case imageURLs = "images"
    }
    
    init(with decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let numberOfLikes = try container.decode(Int.self, forKey: .numberOfLikes)
        let id = try container.decode(Int.self, forKey: .id)
        let description = try container.decode(String.self, forKey: .description)
        var imageContainer = try container.nestedUnkeyedContainer(forKey: .imageURLs)
        var imageURLs: [ImageURL] = []
        while !imageContainer.isAtEnd {
            let nestedURL = try imageContainer.decode([ImageURL].self)
            imageURLs.append(contentsOf: nestedURL)
        }
        
        self.init(title: title, id: id, numberOfLikes: numberOfLikes, description: description, imageURLs: imageURLs)
        
    }
    
    init(title: String, id:Int, numberOfLikes: Int, description: String, imageURLs: [ImageURL]) {
        self.title = title
        self.id = id
        self.numberOfLikes = numberOfLikes
        self.description = description
        self.imageURLs = imageURLs
    }
    
}

struct ImageURL: Decodable {
    let url: String
}
