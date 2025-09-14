
import SwiftUI

enum Screens: CaseIterable {
    case launchScreen
    case onboarding
    case profile
    case gameView
}

final class Coordinator: ObservableObject {
    @Published var actualScreen: Screens
    private let userService: UserService
    private let storageService: StorageServiceProtocol
    
    private var hasSeenOnboarding: Bool {
        get { storageService.loadBool(forKey: "hasSeenOnboarding") }
        set { storageService.saveBool(newValue, forKey: "hasSeenOnboarding") }
    }
    
    init(storageService: StorageServiceProtocol = UserDefaultsStorageService()) {
        self.storageService = storageService
        self.userService = UserService(storageService: storageService)
        // Start with launch screen
        actualScreen = .launchScreen
        
        // Auto-navigate after launch screen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkInitialScreen()
        }
    }
    
    private func checkInitialScreen() {
        withAnimation(.spring(duration: 0.5)) {
            if !hasSeenOnboarding || !userService.profile.hasProfile {
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
                ProfileView(userService: coordinator.getUserService(), coordinator: coordinator)
                
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
