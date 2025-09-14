import Foundation

final class AppDependencies {
    lazy var storageService: StorageServiceProtocol = UserDefaultsStorageService()
    
    lazy var userService: UserService = UserService(storageService: storageService)
    lazy var storyService: StoryService = StoryService()
    lazy var onboardingService: OnboardingServiceProtocol = OnboardingService(storageService: storageService)
    lazy var permissionManager: PermissionManagerProtocol = PermissionManager()
    
    lazy var navigationCoordinator: NavigationCoordinator = NavigationCoordinator(
        userService: userService,
        onboardingService: onboardingService,
        permissionManager: permissionManager
    )
}
