import SwiftUI
import UIKit

final class ProfileViewModel: ObservableObject {
    @Published var tempUserName = ""
    @Published var selectedImage: UIImage?
    @Published var showImagePicker = false
    @Published var showCamera = false
    @Published var showDeleteAlert = false
    @Published var showPermissionAlert = false
    
    @ObservedObject private var userService: UserService
    private let coordinator: NavigationCoordinator
    let permissionManager: PermissionManagerProtocol
    
    private var pendingPermissionType: PermissionType?
    
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
    
    init(userService: UserService, coordinator: NavigationCoordinator, permissionManager: PermissionManagerProtocol = PermissionManager()) {
        self.userService = userService
        self.coordinator = coordinator
        self.permissionManager = permissionManager
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
    
    func openGallery() {
        let status = permissionManager.checkPhotoLibraryPermission()
        
        switch status {
        case .authorized, .limited:
            showImagePicker = true
        case .notDetermined:
            permissionManager.requestPhotoLibraryPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.showImagePicker = true
                    } else {
                        self?.showPermissionDeniedAlert(for: .photoLibrary)
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert(for: .photoLibrary)
        }
    }
    
    func openCamera() {
        let status = permissionManager.checkCameraPermission()
        
        switch status {
        case .authorized:
            showCamera = true
        case .notDetermined:
            permissionManager.requestCameraPermission { [weak self] granted in
                DispatchQueue.main.async {
                    if granted {
                        self?.showCamera = true
                    } else {
                        self?.showPermissionDeniedAlert(for: .camera)
                    }
                }
            }
        case .denied, .restricted:
            showPermissionDeniedAlert(for: .camera)
        case .limited:
            showCamera = true
        }
    }
    
    private func showPermissionDeniedAlert(for type: PermissionType) {
        pendingPermissionType = type
        showPermissionAlert = true
    }
    
    func openAppSettings() {
        permissionManager.openAppSettings()
    }
    
    var permissionAlertTitle: String {
        guard let type = pendingPermissionType else { return "" }
        switch type {
        case .camera:
            return "Camera Access Required"
        case .photoLibrary:
            return "Photo Library Access Required"
        }
    }
    
    var permissionAlertMessage: String {
        guard let type = pendingPermissionType else { return "" }
        switch type {
        case .camera:
            return "Chicken Adventure needs access to your camera to take photos for your profile avatar. Please go to Settings to enable camera access."
        case .photoLibrary:
            return "Chicken Adventure needs access to your photo library to select images for your profile avatar. Please go to Settings to enable photo library access."
        }
    }
}
