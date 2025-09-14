
import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel: OnboardingViewModel
    
    init(coordinator: NavigationCoordinator) {
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(navigationCoordinator: coordinator))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            ProgressIndicator(
                currentStep: viewModel.currentPage,
                totalSteps: OnboardingData.pages.count
            )
            .padding(.top, 60)
            
            Spacer()
            
            // Content
            TabView(selection: $viewModel.currentPage) {
                ForEach(0..<OnboardingData.pages.count, id: \.self) { index in
                    OnboardingPageView(page: OnboardingData.pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: viewModel.currentPage)
            
            Spacer()
            
            // Navigation buttons
            HStack(spacing: 20) {
                if viewModel.canGoBack {
                    SecondaryButton("Previous") {
                        viewModel.previousPage()
                    }
                }
                
                Spacer()
                
                PrimaryButton(viewModel.isLastPage ? "Get Started" : "Next") {
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
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            // Image
            Image(page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 10)
            
            VStack(spacing: 20) {
                Text(page.title)
                    .font(AppTheme.typography.title1)
                    .foregroundColor(.appDarkPink)
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(AppTheme.typography.bodyLarge)
                    .foregroundColor(.appDarkPink.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 40)
        }
    }
}


#Preview {
    let dependencies = AppDependencies()
    return OnboardingView(coordinator: dependencies.navigationCoordinator)
}


import Foundation

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
}

final class OnboardingData {
    static let pages = [
        OnboardingPage(
            title: "Welcome to Chicken Adventure",
            description: "Embark on an interactive story where every choice matters. Follow our brave chicken on an incredible journey of self-discovery.",
            imageName: "Background"
        ),
        OnboardingPage(
            title: "Choose Your Path",
            description: "Make decisions that will shape your destiny. Will you learn to fly, start a family, rebel, or explore the world?",
            imageName: "Background"
        ),
        OnboardingPage(
            title: "Multiple Endings Await",
            description: "Your choices lead to unique endings. Create your profile and start your adventure!",
            imageName: "Background"
        )
    ]
}
