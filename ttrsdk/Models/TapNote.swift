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
	
	func setRevenge(_ revenge: Bool) {
		if revenge {
			sprite.texture = SKTexture(imageNamed: "RevRed")
		} else {
			switch type {
				case .red: sprite.texture = SKTexture(imageNamed: "Red")
				case .green: sprite.texture = SKTexture(imageNamed: "Green")
				case .blue: sprite.texture = SKTexture(imageNamed: "Blue")
				default: break
			}
		}
	}
}
