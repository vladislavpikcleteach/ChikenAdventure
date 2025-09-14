
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
                        showEndingImage = false
                    } label: {
                        Image(systemName: viewModel.restartIconName)
                            .font(.title2)
                            .foregroundColor(.appDarkPink)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.top, 20)
                
                if viewModel.isEndingReached {
                    // Для концовки - добавляем Spacer чтобы текст опустился вниз
                    Spacer()
                    sceneText
                    choiceButtonsContainer
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 40)
                } else {
                    // Для обычной игры - все как было
                    sceneText
                        .padding(.top, 60)
                    
                    choiceButtonsContainer
                        .padding(.horizontal, 20)
                        .padding(.top, 30)
                        .padding(.bottom, 40)
                }
            }
        }
        .background(endingBackgroundView)
        .onChange(of: viewModel.isEndingReached) { oldValue, newValue in
            if newValue {
                showEndingImage = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showEndingImage = true
                }
            } else {
                showEndingImage = false
            }
        }
    }
    
    
    private var endingBackgroundView: some View {
        Group {
            if viewModel.isEndingReached, let imageName = viewModel.activeEndingImageName {
                // Полноэкранная картинка концовки
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .scaleEffect(showEndingImage ? 1.0 : 1.2)
                    .opacity(showEndingImage ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 1.2), value: showEndingImage)
            } else {
                // Обычный фон когда концовка не достигнута
                AppBackground()
            }
        }
    }
    
    private var sceneText: some View {
        Group {
            if viewModel.isEndingReached {
                // Непрозрачная карточка для концовки
                ScrollableTextView(text: viewModel.currentText)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius.card)
                            .fill(Color.appLightYellow) // БЕЗ opacity!
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.cornerRadius.card)
                            .stroke(Color.appLightPink, lineWidth: 1)
                    )
                    .shadow(radius: 5)
            } else {
                // Обычная карточка
                AppCard {
                    ScrollableTextView(text: viewModel.currentText)
                }
            }
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
