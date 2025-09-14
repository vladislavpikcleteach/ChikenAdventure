import SwiftUI

struct GameView: View {
    @StateObject private var viewModel = GameViewModel()
    private let coordinator: NavigationCoordinator
    
    init(coordinator: NavigationCoordinator) {
        self.coordinator = coordinator
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        coordinator.navigate(to: .profile)
                    } label: {
                        Image(systemName: viewModel.profileIconName)
                            .font(.title2)
                            .foregroundColor(.appDarkPink)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.restart()
                    } label: {
                        Image(systemName: viewModel.restartIconName)
                            .font(.title2)
                            .foregroundColor(.appDarkPink)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                sceneText
                    .padding(.top, 60)
                
                choiceButtonsContainer
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                    .padding(.bottom, 40)
            }
        }
        .background(endingBackgroundView)
    }
    
    
    private var endingBackgroundView: some View {
        Group {
            if viewModel.isEndingReached, let imageName = viewModel.activeEndingImageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            } else {
                AppBackground()
            }
        }
    }
    
    private var sceneText: some View {
        Group {
            ScrollableTextView(text: viewModel.currentText)
                .padding(.horizontal, 20)
        }
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
