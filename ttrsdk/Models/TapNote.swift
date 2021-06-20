import Foundation
import SpriteKit

enum TapType {
	case red
	case green
	case blue
	case left
	case up
	case right
}

enum TapJudgement {
	case perfect
	case good
	case bad
}

class TapNote {
	var sprite: SKSpriteNode!
	var startTime: CGFloat!
	var type: TapType!
	
	init(type: TapType, startTime: CGFloat) {
		self.type = type
		self.startTime = startTime
		
		switch type {
			case .red:
				sprite = SKSpriteNode(imageNamed: "Red")
			case .green:
				sprite = SKSpriteNode(imageNamed: "Green")
			case .blue:
				sprite = SKSpriteNode(imageNamed: "Blue")
			default: break
		}
	}
	
	init(type: TapType, endTime: CGFloat) {
		self.type = type
		self.startTime = endTime - 2
		
		switch type {
			case .red:
				sprite = SKSpriteNode(imageNamed: "Red")
			case .green:
				sprite = SKSpriteNode(imageNamed: "Green")
			case .blue:
				sprite = SKSpriteNode(imageNamed: "Blue")
			default:
				break
		}
	}
}
