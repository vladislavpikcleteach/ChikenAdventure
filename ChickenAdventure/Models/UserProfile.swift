import Foundation

struct UserProfileModel: Codable {
    var userName: String
    var hasAvatar: Bool
    
    init(userName: String = "", hasAvatar: Bool = false) {
        self.userName = userName
        self.hasAvatar = hasAvatar
    }
    
    var hasProfile: Bool {
        !userName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
