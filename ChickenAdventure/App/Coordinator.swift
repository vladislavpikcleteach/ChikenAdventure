
import SwiftUI

enum Screens {
    case launch
}

final class Coordinator: ObservableObject {
    @Published var actualScreen: Screens
    
    init() {
        actualScreen = .launch
    }
    
    
    func navigate(to screen: Screens) {
        if actualScreen != screen {
            withAnimation(.spring(duration: 0.5)) {
                actualScreen = screen
            }
        }
    }
}

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        Group {
            switch coordinator.actualScreen {
            case .launch:
                LauchScreenView()
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
