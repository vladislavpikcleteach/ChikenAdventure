import Foundation

// MARK: - EndingType
enum EndingType: String, CaseIterable {
    case flight = "flight"
    case family = "family"
    case prison = "prison"
    case travel = "travel"
    
    var imageName: String {
        switch self {
        case .flight: return "TheСhickenLearnedToFly"
        case .family: return "TheChickenStartedAFamily"
        case .prison: return "ChickenSatInPrison"
        case .travel: return "TheChickenBecameATraveler"
        }
    }
}

// MARK: - StoryNode
final class StoryNode: Identifiable, ObservableObject {
    let id = UUID()
    let text: String
    var choices: [StoryChoice] = []
    let endingType: EndingType?
    
    init(text: String, endingType: EndingType? = nil) {
        self.text = text
        self.endingType = endingType
    }
}

// MARK: - StoryChoice
struct StoryChoice: Identifiable {
    let id = UUID()
    let text: String
    let nextNode: StoryNode?
    let switchEndingTo: EndingType?
    
    init(text: String, nextNode: StoryNode?, switchEndingTo: EndingType? = nil) {
        self.text = text
        self.nextNode = nextNode
        self.switchEndingTo = switchEndingTo
    }
}
