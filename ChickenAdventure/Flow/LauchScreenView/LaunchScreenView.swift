
import SwiftUI

struct LaunchScreenView: View {
    @StateObject private var viewModel = LaunchViewModel()
    
    var body: some View {
        ZStack {
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
