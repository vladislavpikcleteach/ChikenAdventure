import SwiftUI

final class OnboardingViewModel: ObservableObject {
    @Published var currentPage = 0
    
    private let navigationCoordinator: any NavigationCoordinatorProtocol
    
    // MARK: - Data
    let titles = [
        "Welcome to Chicken Adventure",
        "Choose Your Path",
        "Multiple Endings Await"
    ]
    
    let descriptions = [
        "Embark on an interactive story where every choice matters. Follow our brave chicken on an incredible journey.",
        "Make decisions that will shape your destiny. Will you learn to fly, start a family, rebel, or explore the world?",
        "Your choices lead to unique endings. Create your profile and start your adventure!"
    ]
    
    let imageName = "Background"
    let totalPages = 3
    
    // MARK: - Init
    init(navigationCoordinator: any NavigationCoordinatorProtocol) {
        self.navigationCoordinator = navigationCoordinator
    }
    
    // MARK: - Computed Properties
    var currentTitle: String {
        titles[currentPage]
    }
    
    var currentDescription: String {
        descriptions[currentPage]
    }
    
    var isLastPage: Bool {
        currentPage == totalPages - 1
    }
    
    var canGoBack: Bool {
        currentPage > 0
    }
    
    // MARK: - Actions
    func nextPage() {
        if currentPage < totalPages - 1 {
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
}
