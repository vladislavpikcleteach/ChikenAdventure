import SwiftUI
import UIKit

final class ProfileViewModel: ObservableObject {
    @Published var tempUserName = ""
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showCamera = false
    @Published var showDeleteAlert = false
    
    @ObservedObject private var userService: UserService
    private let coordinator: NavigationCoordinator
    
    var canSave: Bool {
        !tempUserName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var userProfile: UserProfileModel {
        userService.profile
    }
    
    var avatarImage: UIImage? {
        userService.avatarImage
    }
    
    init(userService: UserService, coordinator: NavigationCoordinator) {
        self.userService = userService
        self.coordinator = coordinator
        self.tempUserName = userService.profile.userName
    }
    
    func startAdventure() {
        userService.updateUserName(tempUserName)
        if let selectedImage = selectedImage {
            userService.updateAvatarImage(selectedImage)
        }
        userService.saveProfile()
        coordinator.navigate(to: .gameView)
    }
    
    func deleteProfile() {
        userService.deleteProfile()
        tempUserName = ""
        selectedImage = nil
    }
    
    func skipForNow() {
        coordinator.navigate(to: .gameView)
    }
    
    func updateSelectedImage(_ image: UIImage?) {
        selectedImage = image
        if let image = image {
            userService.updateAvatarImage(image)
        }
    }
}
