
import SwiftUI

struct LaunchScreenView: View {
    @StateObject private var viewModel = LaunchViewModel()
    
    var body: some View {
        ZStack {
            // Background (повторно задається як вимагає користувач)
            Image("Background")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                Text("Chicken Adventure")
                    .font(.primaryBold(size: 32))
                    .foregroundColor(.appDarkPink)
                    .shadow(radius: 5)
                
                Spacer()
                
                // Loading indicator
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.appLightPink)
                            .frame(width: 12, height: 12)
                            .scaleEffect(viewModel.isAnimating ? 1.2 : 0.8)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: viewModel.isAnimating
                            )
                    }
                }
                .padding(.bottom, 60)
            }
        }
        .onAppear {
            viewModel.startAnimations()
        }
    }
}

#Preview {
    LaunchScreenView()
}
