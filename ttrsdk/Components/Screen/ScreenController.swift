import Foundation
import SpriteKit
import UIKit

class ScreenController: UIViewController {
	let scene = ScreenScene(size: UIScreen.main.bounds.size)
	
	override func viewDidLoad() {
		scene.scaleMode = .aspectFit
		scene.pause = pause
		
		let skView = view as! SKView
		skView.presentScene(scene)
		
		let notificationCenter = NotificationCenter.default
		notificationCenter.addObserver(self, selector: #selector(pause), name: UIApplication.willResignActiveNotification, object: nil)
	}
	
	@objc func pause() {
		let alert = UIAlertController(title: "Paused")
		scene.isPaused = true
		present(alert, animated: true, completion: nil)
	}
}
