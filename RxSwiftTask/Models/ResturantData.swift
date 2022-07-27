
import Foundation

// MARK: - WelcomeElement
struct ResturantData: Codable {
    let name, offer, welcomeDescription: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case name, offer
        case welcomeDescription = "description"
        case imageURL = "image_url"
    }
}
