import UIKit
import AVFoundation
import Photos

// MARK: - Permission Status
enum PermissionStatus {
    case authorized
    case denied
    case notDetermined
    case restricted
    case limited // Only for Photos
}

// MARK: - Permission Type
enum PermissionType {
    case camera
    case photoLibrary
}

// MARK: - Permission Manager Protocol
protocol PermissionManagerProtocol {
    func checkCameraPermission() -> PermissionStatus
    func checkPhotoLibraryPermission() -> PermissionStatus
    func requestCameraPermission(completion: @escaping (Bool) -> Void)
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void)
    func openAppSettings()
    func createPermissionAlert(
        for permissionType: PermissionType,
        onSettings: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> UIAlertController
}

// MARK: - Permission Manager
final class PermissionManager: PermissionManagerProtocol {
    
    // MARK: - Camera Permission
    func checkCameraPermission() -> PermissionStatus {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        @unknown default:
            return .denied
        }
    }
    
    func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    // MARK: - Photo Library Permission
    func checkPhotoLibraryPermission() -> PermissionStatus {
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch status {
        case .authorized:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .limited:
            return .limited
        @unknown default:
            return .denied
        }
    }
    
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
            DispatchQueue.main.async {
                let granted = status == .authorized || status == .limited
                completion(granted)
            }
        }
    }
    
    // MARK: - Settings Navigation
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

// MARK: - Permission Alert Helper
extension PermissionManager {
    
    func createPermissionAlert(
        for permissionType: PermissionType,
        onSettings: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> UIAlertController {
        
        let (title, message) = getAlertContent(for: permissionType)
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        // Settings Action
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            onSettings()
        }
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            onCancel()
        }
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    private func getAlertContent(for permissionType: PermissionType) -> (String, String) {
        switch permissionType {
        case .camera:
            return (
                "Camera Access Required",
                "Chicken Adventure needs access to your camera to take photos for your profile avatar. Please go to Settings to enable camera access."
            )
        case .photoLibrary:
            return (
                "Photo Library Access Required", 
                "Chicken Adventure needs access to your photo library to select images for your profile avatar. Please go to Settings to enable photo library access."
            )
        }
    }
}
