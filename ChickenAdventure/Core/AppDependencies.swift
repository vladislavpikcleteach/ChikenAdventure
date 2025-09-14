import Foundation

// MARK: - AppDependencies
final class AppDependencies {
    // Storage
    lazy var storageService: StorageServiceProtocol = UserDefaultsStorageService()
    
    // Business Services
    lazy var userService: UserService = UserService(storageService: storageService)
    lazy var storyService: StoryService = StoryService()
    lazy var onboardingService: OnboardingServiceProtocol = OnboardingService(storageService: storageService)
    lazy var permissionManager: PermissionManagerProtocol = PermissionManager()
    
    // Navigation
    lazy var navigationCoordinator: NavigationCoordinator = NavigationCoordinator(
        userService: userService,
        onboardingService: onboardingService,
        permissionManager: permissionManager
    )
}
