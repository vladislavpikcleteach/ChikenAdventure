
import SwiftUI

@main
struct ChickenAdventureApp: App {
    private let dependencies = AppDependencies()
    
    var body: some Scene {
        WindowGroup {
            CoordinatorView(coordinator: dependencies.navigationCoordinator)
        }
    }
}
