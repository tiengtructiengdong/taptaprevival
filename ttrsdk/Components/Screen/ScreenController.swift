import Foundation
import SpriteKit
import UIKit

class ScreenController: UIViewController {
	override func viewDidLoad() {
		let scene = ScreenScene(size: UIScreen.main.bounds.size)
		scene.scaleMode = .aspectFit
		scene.pause = pause
		
		let skView = view as! SKView
		skView.presentScene(scene)
	}
	
	func pause() {
		let alert = UIAlertController(title: "Paused")
		present(alert, animated: true, completion: nil)
	}
}
