import Foundation
import SwiftUI

protocol StoryServiceProtocol: ObservableObject {
    var currentNode: StoryNode { get }
    var activeEnding: EndingType? { get }
    var isEndingReached: Bool { get }
    
    func selectChoice(_ choice: StoryChoice)
    func restart()
}

final class StoryService: ObservableObject, StoryServiceProtocol {
    @Published private(set) var currentNode: StoryNode
    @Published private(set) var activeEnding: EndingType?
    @Published private(set) var isEndingReached = false
    
    private let rootNode: StoryNode
    
    init() {
        let flightEnding = StoryNode(
            text: "You spread your wings wide, feeling the wind beneath your feathers. The farm below grows smaller as you soar higher than any chicken has ever dared to dream. You are free, you are flying, you are limitless.",
            endingType: .flight
        )
        
        let familyEnding = StoryNode(
            text: "Surrounded by your fluffy chicks, you feel a warmth that no adventure could replace. Your partner nuzzles close as the sunset paints the coop golden. This simple life, filled with love and laughter, is your greatest treasure.",
            endingType: .family
        )
        
        let prisonEnding = StoryNode(
            text: "Behind the cold metal bars, you contemplate your choices. The rebellion was fierce, but the consequences are real. Yet even here, you plan your next move. Some say the strongest cages hold the most dangerous dreams.",
            endingType: .prison
        )
        
        let travelEnding = StoryNode(
            text: "With a worn map tucked under your wing and endless horizons ahead, you've become a legend among travelers. Each sunrise brings new wonders, each sunset new stories to tell. The world is your coop now.",
            endingType: .travel
        )
        
        let flight1 = StoryNode(text: "You climb onto the highest perch in the coop. The other chickens cluck nervously below. Your heart pounds with anticipation and fear. This is it – the moment you've been preparing for.")
        let flight2 = StoryNode(text: "You begin flapping your wings frantically, trying to remember everything you learned from watching the sparrows. The ground seems so far away, but freedom calls to you.")
        let flight3 = StoryNode(text: "You feel yourself lifting slightly off the perch. It's working! But the farmer is approaching with a concerned look. Do you trust in your abilities?")
        
        let family1 = StoryNode(text: "You notice another chicken who seems different from the rest – kind eyes and a gentle manner. There's something special about building a life together.")
        let family2 = StoryNode(text: "You and your partner work together to create the perfect nest. The bond between you grows stronger each day, and you both dream of little chicks.")
        let family3 = StoryNode(text: "Your first egg arrives! You and your partner take turns keeping it warm, dreaming of the new life that will soon join your family.")
        
        let prison1 = StoryNode(text: "You've had enough of the farmer's rules. The fence seems more like a prison than protection. You start rallying other chickens to your cause.")
        let prison2 = StoryNode(text: "Your rebellion grows stronger. You lead raids on the chicken feed and refuse to lay eggs. The farmer looks increasingly frustrated with your behavior.")
        let prison3 = StoryNode(text: "The farmer has decided you're too much trouble. You see them approaching with a cage. This could be the end of your freedom.")
        
        let travel1 = StoryNode(text: "Beyond the farm fence, you see a road stretching toward distant mountains. Your heart yearns for adventure and unknown lands.")
        let travel2 = StoryNode(text: "You slip through a gap in the fence one moonless night. The world beyond is vast and mysterious, full of possibilities and dangers.")
        let travel3 = StoryNode(text: "You meet a group of wild birds who offer to show you the ways of the world. They speak of distant lands and incredible sights.")
        
        let root = StoryNode(text: "You wake up in your coop as dawn breaks over the farm. Around you, other chickens go about their daily routine of pecking and clucking. But you feel different today. Deep in your heart, you know you're meant for something more than this ordinary life. What path will you choose?"        )
        
        flight1.choices = [
            StoryChoice(text: "Practice flapping more", nextNode: flight2, switchEndingTo: nil),
            StoryChoice(text: "Look for a partner instead", nextNode: family1, switchEndingTo: .family),
            StoryChoice(text: "Consider running away", nextNode: travel1, switchEndingTo: .travel)
        ]
        
        flight2.choices = [
            StoryChoice(text: "Jump and trust your wings", nextNode: flight3, switchEndingTo: nil),
            StoryChoice(text: "Give up and start a rebellion", nextNode: prison1, switchEndingTo: .prison)
        ]
        
        flight3.choices = [
            StoryChoice(text: "Take the leap of faith", nextNode: flightEnding, switchEndingTo: nil),
            StoryChoice(text: "Play it safe and settle down", nextNode: family1, switchEndingTo: .family)
        ]
        
        family1.choices = [
            StoryChoice(text: "Approach them", nextNode: family2, switchEndingTo: nil),
            StoryChoice(text: "Focus on your own dreams", nextNode: flight1, switchEndingTo: .flight)
        ]
        
        family2.choices = [
            StoryChoice(text: "Commit to this life", nextNode: family3, switchEndingTo: nil),
            StoryChoice(text: "Doubt your choice", nextNode: travel1, switchEndingTo: .travel)
        ]
        
        family3.choices = [
            StoryChoice(text: "Embrace parenthood", nextNode: familyEnding, switchEndingTo: nil),
            StoryChoice(text: "Feel trapped by responsibility", nextNode: prison1, switchEndingTo: .prison)
        ]
        
        prison1.choices = [
            StoryChoice(text: "Continue the rebellion", nextNode: prison2, switchEndingTo: nil),
            StoryChoice(text: "Try to escape alone", nextNode: travel1, switchEndingTo: .travel)
        ]
        
        prison2.choices = [
            StoryChoice(text: "Escalate the fight", nextNode: prison3, switchEndingTo: nil),
            StoryChoice(text: "Try to fly away", nextNode: flight1, switchEndingTo: .flight)
        ]
        
        prison3.choices = [
            StoryChoice(text: "Accept your fate defiantly", nextNode: prisonEnding, switchEndingTo: nil),
            StoryChoice(text: "Make one last escape attempt", nextNode: travel1, switchEndingTo: .travel)
        ]
        
        travel1.choices = [
            StoryChoice(text: "Leave the farm tonight", nextNode: travel2, switchEndingTo: nil),
            StoryChoice(text: "Stay and find love first", nextNode: family1, switchEndingTo: .family)
        ]
        
        travel2.choices = [
            StoryChoice(text: "Join the wild birds", nextNode: travel3, switchEndingTo: nil),
            StoryChoice(text: "Try to fly back home", nextNode: flight1, switchEndingTo: .flight)
        ]
        
        travel3.choices = [
            StoryChoice(text: "Embrace the nomad life", nextNode: travelEnding, switchEndingTo: nil),
            StoryChoice(text: "Rebel against their rules", nextNode: prison1, switchEndingTo: .prison)
        ]
        
        root.choices = [
            StoryChoice(text: "Practice flying", nextNode: flight1, switchEndingTo: .flight),
            StoryChoice(text: "Look for companionship", nextNode: family1, switchEndingTo: .family),
            StoryChoice(text: "Challenge the farmer", nextNode: prison1, switchEndingTo: .prison),
            StoryChoice(text: "Explore beyond the fence", nextNode: travel1, switchEndingTo: .travel)
        ]
        
        self.rootNode = root
        self.currentNode = root
        self.activeEnding = nil
    }
    
    func selectChoice(_ choice: StoryChoice) {
        if let switchEnding = choice.switchEndingTo {
            activeEnding = switchEnding
        }
        guard let next = choice.nextNode else { return }
        currentNode = next
        if let ending = next.endingType {
            activeEnding = ending
            isEndingReached = true
        }
    }
    
    func restart() {
        currentNode = rootNode
        activeEnding = nil
        isEndingReached = false
    }
}
