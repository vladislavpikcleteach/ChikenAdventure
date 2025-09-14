
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published private(set) var currentText: String = ""
    @Published private(set) var choices: [StoryChoice] = []
    @Published private(set) var isEndingReached: Bool = false
    @Published private(set) var activeEndingImageName: String? = nil
    
    private let storyModel = StoryModel()
    
    init() {
        updateState()
    }
    
    func makeChoice(_ choice: StoryChoice) {
        storyModel.selectChoice(choice)
        updateState()
    }
    
    func restart() {
        storyModel.restart()
        updateState()
    }
    
    private func updateState() {
        currentText = storyModel.currentNode.text
        choices = storyModel.currentNode.choices
        isEndingReached = storyModel.isEndingReached
        activeEndingImageName = storyModel.activeEnding?.imageName
    }
}

