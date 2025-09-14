import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    
    private let navigationCoordinator: NavigationCoordinatorProtocol
    
    init(navigationCoordinator: NavigationCoordinatorProtocol) {
        self.navigationCoordinator = navigationCoordinator
    }
    
    func nextPage() {
        if currentPage < OnboardingData.pages.count - 1 {
            withAnimation {
                currentPage += 1
            }
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation {
                currentPage -= 1
            }
        }
    }
    
    func completeOnboarding() {
        navigationCoordinator.completeOnboarding()
    }
    
    var isLastPage: Bool {
        currentPage == OnboardingData.pages.count - 1
    }
    
    var canGoBack: Bool {
        currentPage > 0
    }
}
