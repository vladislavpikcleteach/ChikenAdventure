
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var currentPage = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Progress indicator
            HStack(spacing: 8) {
                ForEach(0..<OnboardingData.pages.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color("orangeColor") : Color("lightPinkColor").opacity(0.3))
                        .frame(width: 10, height: 10)
                        .animation(.easeInOut, value: currentPage)
                }
            }
            .padding(.top, 60)
            
            Spacer()
            
            // Content
            TabView(selection: $currentPage) {
                ForEach(0..<OnboardingData.pages.count, id: \.self) { index in
                    OnboardingPageView(page: OnboardingData.pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            
            Spacer()
            
            // Navigation buttons
            HStack(spacing: 20) {
                if currentPage > 0 {
                    Button("Previous") {
                        withAnimation {
                            currentPage -= 1
                        }
                    }
                    .buttonStyle(SecondaryButtonStyle())
                }
                
                Spacer()
                
                Button(currentPage == OnboardingData.pages.count - 1 ? "Get Started" : "Next") {
                    if currentPage == OnboardingData.pages.count - 1 {
                        coordinator.completeOnboarding()
                    } else {
                        withAnimation {
                            currentPage += 1
                        }
                    }
                }
                .buttonStyle(PrimaryButtonStyle())
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
                    .font(.primaryBold(size: 28))
                    .foregroundColor(Color("darkPinkColor"))
                    .multilineTextAlignment(.center)
                
                Text(page.description)
                    .font(.primaryRegular(size: 18))
                    .foregroundColor(Color("darkPinkColor").opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 40)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.primaryBold(size: 18))
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [Color("orangeColor"), Color("yellowColor")],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(radius: configuration.isPressed ? 2 : 5)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.primaryRegular(size: 16))
            .foregroundColor(Color("darkPinkColor"))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("lightPinkColor"), lineWidth: 2)
                    .background(Color("lightYellowColor").opacity(0.3))
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(Coordinator())
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
