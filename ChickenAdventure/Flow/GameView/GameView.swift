
import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    private let coordinator: NavigationCoordinator
    
    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
    }
    @State private var showEndingImage = false
    
    var body: some View {
        ScrollView {
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
                    .padding(.top, 30)
                
                choiceButtonsContainer
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 40)
            }
        }
    }
    
    private var chickenAvatar: some View {
        ChickenAvatar()
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
        AppCard {
            ScrollableTextView(text: viewModel.currentText)
        }
        .padding(.horizontal, AppTheme.spacing.cardPadding)
    }
    
    private var choiceButtonsContainer: some View {
        VStack(spacing: 15) {
            ForEach(Array(viewModel.choices.enumerated()), id: \.offset) { index, choice in
                StoryChoiceButton(choice.text) {
                    viewModel.makeChoice(choice)
                }
            }
        }
        .padding(.horizontal, 10)
        .animation(nil, value: viewModel.choices.count)
    }
}


#Preview {
    let dependencies = AppDependencies()
    return GameView(coordinator: dependencies.navigationCoordinator)
}
