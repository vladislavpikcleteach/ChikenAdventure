import UIKit
import AVFoundation
import Photos

enum PermissionStatus {
    case authorized
    case denied
    case notDetermined
    case restricted
    case limited
}

enum PermissionType {
    case camera
    case photoLibrary
}

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

final class PermissionManager: PermissionManagerProtocol {
    
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
    
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}

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
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            onSettings()
        }
        
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
