import SwiftUI
import UIKit

protocol UserServiceProtocol: ObservableObject {
    var profile: UserProfileModel { get }
    var avatarImage: UIImage? { get set }
    
    func updateUserName(_ name: String)
    func updateAvatarImage(_ image: UIImage?)
    func saveProfile()
    func deleteProfile()
    func loadProfile()
}

final class UserService: UserServiceProtocol {
    @Published var profile = UserProfileModel()
    @Published var avatarImage: UIImage?
    
    private let storageService: StorageServiceProtocol
    
    private let profileKey = "userProfile"
    private let avatarImageKey = "avatarImage"
    
    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
        loadProfile()
    }
    
    func updateUserName(_ name: String) {
        profile.userName = name
    }
    
    func updateAvatarImage(_ image: UIImage?) {
        avatarImage = image
        profile.hasAvatar = (image != nil)
    }
    
    func saveProfile() {
        storageService.save(profile, forKey: profileKey)
        
        
        if let avatarImage = avatarImage,
           let imageData = avatarImage.jpegData(compressionQuality: 0.8) {
            storageService.saveData(imageData, forKey: avatarImageKey)
        } else {
            storageService.remove(forKey: avatarImageKey)
        }
    }
    
    func deleteProfile() {
        profile = UserProfileModel()
        avatarImage = nil
        storageService.remove(forKey: profileKey)
        storageService.remove(forKey: avatarImageKey)
    }
    
    func loadProfile() {
        if let loadedProfile = storageService.load(UserProfileModel.self, forKey: profileKey) {
            profile = loadedProfile
        }
        
        if let imageData = storageService.loadData(forKey: avatarImageKey),
           let image = UIImage(data: imageData) {
            avatarImage = image
        }
    }
}
