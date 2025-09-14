import SwiftUI
import UIKit

// MARK: - UserServiceProtocol
protocol UserServiceProtocol: ObservableObject {
    var profile: UserProfileModel { get }
    var avatarImage: UIImage? { get set }
    
    func updateUserName(_ name: String)
    func updateAvatarImage(_ image: UIImage?)
    func saveProfile()
    func deleteProfile()
    func loadProfile()
}

// MARK: - UserService
final class UserService: UserServiceProtocol {
    @Published var profile = UserProfileModel()
    @Published var avatarImage: UIImage?
    
    private let storageService: StorageServiceProtocol
    
    // Storage keys
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
        // Save profile model
        storageService.save(profile, forKey: profileKey)
        
        // Save avatar image
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
        // Load profile model
        if let loadedProfile = storageService.load(UserProfileModel.self, forKey: profileKey) {
            profile = loadedProfile
        }
        
        // Load avatar image
        if let imageData = storageService.loadData(forKey: avatarImageKey),
           let image = UIImage(data: imageData) {
            avatarImage = image
        }
    }
}
