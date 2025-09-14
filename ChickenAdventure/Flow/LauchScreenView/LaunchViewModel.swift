import SwiftUI

final class LaunchViewModel: ObservableObject {
    @Published var isAnimating = false
    @Published var pulseScale: CGFloat = 1.0
    @Published var rotationAngle: Double = 0
    
    // MARK: - UI Text
    let appTitle = "Chicken Adventure"
    
    func startAnimations() {
        isAnimating = true
        
        // Pulse animation
        withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
            pulseScale = 1.15
        }
        
        // Rotation animation
        withAnimation(.linear(duration: 4.0).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
}
