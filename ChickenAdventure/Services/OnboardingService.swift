import Foundation

protocol OnboardingServiceProtocol {
    var hasSeenOnboarding: Bool { get set }
    func completeOnboarding()
}

final class OnboardingService: OnboardingServiceProtocol {
    var hasSeenOnboarding: Bool {
        get { storageService.loadBool(forKey: "hasSeenOnboarding") }
        set { storageService.saveBool(newValue, forKey: "hasSeenOnboarding") }
    }
    
    private let storageService: StorageServiceProtocol
    
    init(storageService: StorageServiceProtocol) {
        self.storageService = storageService
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
    }
}
