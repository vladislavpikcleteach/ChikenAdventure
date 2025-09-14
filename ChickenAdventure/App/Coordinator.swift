
import SwiftUI

enum Screens: CaseIterable {
    case launchScreen
    case onboarding
    case profile
    case gameView
}

final class Coordinator: ObservableObject {
    @Published var actualScreen: Screens
    @StateObject private var userProfile = UserProfile()
    
    private var hasSeenOnboarding: Bool {
        get { UserDefaults.standard.bool(forKey: "hasSeenOnboarding") }
        set { UserDefaults.standard.set(newValue, forKey: "hasSeenOnboarding") }
    }
    
    init() {
        // Start with launch screen
        actualScreen = .launchScreen
        
        // Auto-navigate after launch screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkInitialScreen()
        }
    }
    
    private func checkInitialScreen() {
        withAnimation(.spring(duration: 0.5)) {
            if !hasSeenOnboarding || !userProfile.hasProfile {
                actualScreen = .onboarding
            } else {
                actualScreen = .gameView
            }
        }
    }
    
    func navigate(to screen: Screens) {
        if actualScreen != screen {
            withAnimation(.spring(duration: 0.5)) {
                actualScreen = screen
            }
        }
    }
    
    func completeOnboarding() {
        hasSeenOnboarding = true
        if userProfile.hasProfile {
            navigate(to: .gameView)
        } else {
            navigate(to: .profile)
        }
    }
    
    func getUserProfile() -> UserProfile {
        userProfile
    }
}

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        Group {
            switch coordinator.actualScreen {
            case .launchScreen:
                LaunchScreenView()
                    .environmentObject(coordinator)
                
            case .onboarding:
                OnboardingView()
                    .environmentObject(coordinator)
                
            case .profile:
                ProfileView()
                    .environmentObject(coordinator)
                
            case .gameView:
                GameView()
                    .environmentObject(coordinator)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(backgroundView)
    }
}

private var backgroundView: some View {
    Image("Background")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .ignoresSafeArea()
}

#Preview {
    CoordinatorView()
}
