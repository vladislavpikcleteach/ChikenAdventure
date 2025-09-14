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
    
    // MARK: - UI Texts
    let headerTitle = "Your Profile"
    let headerSubtitle = "Create your identity for the adventure"
    let nameFieldTitle = "Your Name"
    let nameFieldPlaceholder = "Enter your name"
    let galleryButtonTitle = "Gallery"
    let cameraButtonTitle = "Camera"
    let startAdventureButtonTitle = "Start Adventure"
    let deleteProfileButtonTitle = "Delete Profile"
    let skipButtonTitle = "Skip for now"
    let deleteAlertTitle = "Delete Profile"
    let deleteAlertMessage = "Are you sure you want to delete your profile? This action cannot be undone."
    let cancelButtonTitle = "Cancel"
    let deleteButtonTitle = "Delete"
    
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
