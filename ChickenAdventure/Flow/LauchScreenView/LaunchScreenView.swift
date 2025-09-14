
import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    @State private var pulseScale: CGFloat = 1.0
    @State private var rotationAngle: Double = 0
    
    var body: some View {
        ZStack {
            // Background (повторно задається як вимагає користувач)
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Animated chicken icon
                VStack(spacing: 20) {
//                    Image(systemName: "bird.fill")
//                        .font(.system(size: 100))
//                        .foregroundStyle(
//                            LinearGradient(
//                                colors: [
//                                    Color("yellowColor"),
//                                    Color("orangeColor")
//                                ],
//                                startPoint: .topLeading,
//                                endPoint: .bottomTrailing
//                            )
//                        )
//                        .scaleEffect(pulseScale)
//                        .rotationEffect(.degrees(rotationAngle))
//                        .shadow(radius: 10)
                    
                    Text("Chicken Adventure")
                        .font(.primaryBold(size: 32))
                        .foregroundColor(Color("darkPinkColor"))
                        .shadow(radius: 5)
                }
                
                Spacer()
                
                // Loading indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color("lightPinkColor"))
                            .frame(width: 12, height: 12)
                            .scaleEffect(isAnimating ? 1.2 : 0.8)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
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

#Preview {
    LaunchScreenView()
}
