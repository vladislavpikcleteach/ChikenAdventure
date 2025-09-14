
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
                
                    Text(viewModel.appTitle)
                        .font(AppTheme.typography.largeTitle)
                        .foregroundColor(.appDarkPink)
                        .shadow(radius: 5)
                
                Spacer()
                
                // Loading indicator
                LoadingIndicator()
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
