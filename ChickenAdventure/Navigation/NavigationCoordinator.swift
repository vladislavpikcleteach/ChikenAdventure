import SwiftUI

enum AppScreen: CaseIterable {
    case launchScreen
    case onboarding
    case profile
    case gameView
}

// MARK: - NavigationCoordinatorProtocol
protocol NavigationCoordinatorProtocol: ObservableObject {
    var currentScreen: AppScreen { get }
    func navigate(to screen: AppScreen)
    func completeOnboarding()
    func getUserService() -> UserService
}

// MARK: - NavigationCoordinator
final class NavigationCoordinator: NavigationCoordinatorProtocol {
    @Published var currentScreen: AppScreen = .launchScreen
    
    private let userService: UserService
    private let onboardingService: OnboardingServiceProtocol
    
    init(userService: UserService, onboardingService: OnboardingServiceProtocol) {
        self.userService = userService
        self.onboardingService = onboardingService
        
        // Auto-navigate after launch screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkInitialScreen()
        }
    }
    
    private func checkInitialScreen() {
        withAnimation(.spring(duration: 0.5)) {
            if !onboardingService.hasSeenOnboarding || !userService.profile.hasProfile {
                currentScreen = .onboarding
            } else {
                currentScreen = .gameView
            }
        }
    }
    
    func navigate(to screen: AppScreen) {
        if currentScreen != screen {
            withAnimation(.spring(duration: 0.5)) {
                currentScreen = screen
            }
        }
    }
    
    func completeOnboarding() {
        onboardingService.completeOnboarding()
        if userService.profile.hasProfile {
            navigate(to: .gameView)
        } else {
            navigate(to: .profile)
        }
    }
    
    func getUserService() -> UserService {
        userService
    }
}

// MARK: - CoordinatorView
struct CoordinatorView: View {
    @ObservedObject private var coordinator: NavigationCoordinator
    
    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        Group {
            switch coordinator.currentScreen {
            case .launchScreen:
                LaunchScreenView()
                
            case .onboarding:
                OnboardingView(coordinator: coordinator)
                
            case .profile:
                ProfileView(userService: coordinator.getUserService(), coordinator: coordinator)
                
            case .gameView:
                GameView(coordinator: coordinator)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundView)
    }
    
    private var backgroundView: some View {
        Image("Background")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
    }
}

#Preview {
    let dependencies = AppDependencies()
    return CoordinatorView(coordinator: dependencies.navigationCoordinator)
}
