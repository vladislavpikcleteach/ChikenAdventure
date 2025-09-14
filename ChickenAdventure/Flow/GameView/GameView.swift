
import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    private let coordinator: NavigationCoordinator
    
    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
    }
    @State private var showEndingImage = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with profile and restart buttons
            HStack {
                Button {
                    coordinator.navigate(to: .profile)
                } label: {
                    Image(systemName: "person.circle")
                        .font(.title2)
                        .foregroundColor(.appDarkPink)
                }
                
                Spacer()
                
                Button {
                    viewModel.restart()
                    showEndingImage = false
                } label: {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.appDarkPink)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)
            
            chickenAvatar
                .padding(.top, 30)
            
            Spacer()
            
            // Ending image (if reached ending)
            if viewModel.isEndingReached, let imageName = viewModel.activeEndingImageName {
                endingImageView(imageName: imageName)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    .onAppear {
                        showEndingImage = false
                        withAnimation(.spring(duration: 0.8).delay(0.3)) {
                            showEndingImage = true
                        }
                    }
            }
            
            sceneText
            
            Spacer()

            choiceButtonsContainer
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
        }
    }
    
    private var chickenAvatar: some View {
        Image(systemName: "bird.fill")
            .font(.system(size: 80))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color.appYellow,
                        Color.appOrange
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .background(
                Circle()
                    .fill(Color.appLightYellow.opacity(0.3))
                    .frame(width: 120, height: 120)
            )
            .shadow(radius: 5)
    }
    
    private func endingImageView(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 150)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 10)
            .scaleEffect(showEndingImage ? 1.0 : 0.8)
            .opacity(showEndingImage ? 1.0 : 0.0)
    }
    
    private var sceneText: some View {
        Text(viewModel.currentText)
            .font(.primaryRegular(size: 18))
            .foregroundColor(.appDarkPink)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.appLightYellow.opacity(0.3))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.appLightPink, lineWidth: 1)
            )
            .shadow(radius: 5)
            .padding(.horizontal, 20)
    }
    
    private var choiceButtonsContainer: some View {
        VStack(spacing: 15) {
            ForEach(Array(viewModel.choices.enumerated()), id: \.offset) { index, choice in
                Button(choice.text) {
                    viewModel.makeChoice(choice)
                }
                .buttonStyle(StoryChoiceButtonStyle())
            }
        }
        .padding(.horizontal, 10)
    }
}

struct StoryChoiceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.primaryBold(size: 16))
            .foregroundColor(.appDarkPink)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 15)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, minHeight: 80)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appLightYellow.opacity(0.6),
                                Color.appLightPink.opacity(0.4)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.appOrange, lineWidth: 2)
                    )
                    .shadow(radius: configuration.isPressed ? 2 : 5)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    let dependencies = AppDependencies()
    return GameView(coordinator: dependencies.navigationCoordinator)
}
