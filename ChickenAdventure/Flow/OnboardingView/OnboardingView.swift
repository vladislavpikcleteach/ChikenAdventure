
import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    
    init(coordinator: NavigationCoordinator) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(navigationCoordinator: coordinator))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ProgressIndicator(
                currentStep: viewModel.currentPage,
                totalSteps: viewModel.totalPages
            )
            .padding(.top, 60)
            
            Spacer()
            
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<viewModel.totalPages, id: \.self) { index in
                    OnboardingPageView(
                        title: viewModel.titles[index],
                        description: viewModel.descriptions[index],
                        endingImageName: viewModel.endingImages[index]
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentPage)
            
            Spacer()
            
            HStack(spacing: 20) {
                if viewModel.canGoBack {
                    SecondaryButton(viewModel.previousButtonTitle) {
                        viewModel.previousPage()
                    }
                }
                
                Spacer()
                
                PrimaryButton(viewModel.isLastPage ? viewModel.getStartedButtonTitle : viewModel.nextButtonTitle) {
                    if viewModel.isLastPage {
                        viewModel.completeOnboarding()
                    } else {
                        viewModel.nextPage()
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
        }
    }
}

struct OnboardingPageView: View {
    let title: String
    let description: String
    let endingImageName: String
    
    var body: some View {
        VStack(spacing: 20) {
            AppCard {
                Image(endingImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            VStack(spacing: 20) {
                Text(title)
                    .font(AppTheme.typography.title1)
                    .foregroundColor(.appDarkPink)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(AppTheme.typography.bodyLarge)
                    .foregroundColor(.appDarkPink)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 20)
        }
    }
}


#Preview {
    let dependencies = AppDependencies()
    return OnboardingView(coordinator: dependencies.navigationCoordinator)
}
