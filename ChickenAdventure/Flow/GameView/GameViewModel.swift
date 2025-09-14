
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var currentText: String = ""
    @Published var choices: [StoryChoice] = []
    @Published var isEndingReached: Bool = false
    @Published var activeEndingImageName: String? = nil
    
    @ObservedObject private var storyService: StoryService
    
    let profileIconName = "person.circle"
    let restartIconName = "arrow.clockwise"
    
    init(storyService: StoryService = StoryService()) {
        self.storyService = storyService
        updateState()
    }
    
    func makeChoice(_ choice: StoryChoice) {
        storyService.selectChoice(choice)
        updateState()
    }
    
    func restart() {
        storyService.restart()
        updateState()
    }
    
    private func updateState() {
        currentText = storyService.currentNode.text
        choices = storyService.currentNode.choices
        isEndingReached = storyService.isEndingReached
        activeEndingImageName = storyService.activeEnding?.imageName
    }
}
