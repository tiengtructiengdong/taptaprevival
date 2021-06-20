import Foundation
import SpriteKit
import SwifterSwift
import SwiftCSV

class ScreenScene: SKScene {
	let bg = SKSpriteNode(imageNamed: "Scene")
	let glow = SKSpriteNode(imageNamed: "Glow")
	let explosion: [SKSpriteNode] = [
		SKSpriteNode(imageNamed: "RedFlash"),
		SKSpriteNode(imageNamed: "GreenFlash"),
		SKSpriteNode(imageNamed: "BlueFlash")
	]
	
	let scoreLabel = SKLabelNode()
	
	var score: Int = 50000 {
		didSet {
			let scoreShadow = NSShadow()
			scoreShadow.shadowOffset = CGSize(width: 5, height: 10)
			scoreShadow.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
			scoreShadow.shadowBlurRadius = 5
			
			let scoreAttr: [NSAttributedString.Key: Any] = [
				 .foregroundColor: #colorLiteral(red: 1, green: 0.9331807544, blue: 0.5426073789, alpha: 1),
				 .font: UIFont(name: "HelveticaNeue", size: 42)!,
				 .shadow: scoreShadow
			]
			let numberFormatter = NumberFormatter()
			numberFormatter.numberStyle = .decimal
			scoreLabel.attributedText = NSAttributedString(string: numberFormatter.string(from: NSNumber(value: score))!, attributes: scoreAttr)
		}
	}
	var miss: Bool = false {
		didSet {
			if miss {
				let scoreShadow = NSShadow()
				scoreShadow.shadowOffset = CGSize(width: 5, height: 10)
				scoreShadow.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
				scoreShadow.shadowBlurRadius = 5
				
				let scoreAttr: [NSAttributedString.Key: Any] = [
					 .foregroundColor: #colorLiteral(red: 1, green: 0.9331807544, blue: 0.5426073789, alpha: 1),
					 .font: UIFont(name: "HelveticaNeue", size: 45)!,
					 .shadow: scoreShadow
				]
				scoreLabel.attributedText = NSAttributedString(string: "MISS!", attributes: scoreAttr)
			}
		}
	}
	
	var note: [TapNote] = []
	var noteQueue: [TapNote] = []
	
	let width = UIScreen.main.bounds.width
	let height = UIScreen.main.bounds.height
	
	var chart: CSV?
	
	func point(_ x: CGFloat, _ y: CGFloat)->CGPoint {
		return CGPoint(x: width * x, y: height * (1-y))
	}
	func transPoint(_ x: CGFloat, _ y: CGFloat)->CGPoint {
		return CGPoint(x: width * x, y: height * (-y))
	}
	
	var startTime: Double!
	var startPoint: CGPoint!
	
	var isStarted = false
	
	var tapRect: [CGRect] = []
	
	var music: SKAudioNode!
	var pause: (()->Void)!
	
	override func didMove(to view: SKView) {
		addChild(bg)
		bg.position = point(0.5, 0.5)
		bg.scale(to: UIScreen.main.bounds.size)
		
		addChild(glow)
		glow.position = point(0.5, 0.915)
		glow.scale(to: UIScreen.main.bounds.size)
		glow.blendMode = .screen
		glow.yScale = xScale
		
		addChild(scoreLabel)
		score = 1200
		scoreLabel.position = point(0.5, 0.11)
		
		let tapSize = CGSize(width: transPoint(0.25, 0).x, height: -transPoint(0, 0.1).y)
		tapRect = [
			CGRect(origin: transPoint(0.05, -0.85), size: tapSize),
			CGRect(origin: transPoint(0.375, -0.85), size: tapSize),
			CGRect(origin: transPoint(0.7, -0.85), size: tapSize),
			
			CGRect(origin: transPoint(0, -0), size: CGSize(width: transPoint(1, 0.2).x, height: -transPoint(1, 0.2).y)),
		]
		
		for i in 0...2 {
			addChild(explosion[i])
			explosion[i].position = point(0.17 + CGFloat(i)*0.33, 0.88)
			explosion[i].setScale(1.2)
			explosion[i].blendMode = .screen
			explosion[i].alpha = 0
		}
	}
	
	override func sceneDidLoad() {
		super.sceneDidLoad()
		startPoint = point(0.5, 0.06)
		loadChart()
	}
	
	private func loadChart() {
		do {
			chart = try CSV(url: URL(fileURLWithPath: (Bundle.main.resourcePath?.appendingPathComponent("DJ 4Mile - Sololuna (extreme).tap"))!))
			if let chart = chart {
				for row in chart.enumeratedRows {
					if row.count < 4 {
						continue
					}
					
					let n = TapNote(
						type: row[0] == "52.000000" ? .red : row[0] == "160.000000" ? .green : .blue,
						endTime: CGFloat(Float(row[2].trimmed)!)
					)
					n.sprite.position = startPoint
					n.sprite.setScale(0.0)
					note.append(n)
				}
			}
		} catch {}
	}
	
	override func update(_ currentTime: TimeInterval) {
		if let startTime = startTime, isStarted {
			let time = CGFloat(startTime.distance(to: currentTime))
			updateNote(time)
			updateGlow()
		} else if isStarted {
			startTime = currentTime
		} else {
			startMusic()
		}
	}
	
	private func startMusic() {
		music = SKAudioNode(url: URL(fileURLWithPath: (Bundle.main.resourcePath?.appendingPathComponent("DJ 4Mile - Sololuna.m4a"))!))
		self.addChild(music)
		isStarted = true
	}
	
	private func updateNote(_ time: CGFloat) {
		while let first = note.first, time >= CGFloat(first.startTime) {
			let n = note.removeFirst()
			noteQueue.append(n)
			addChild(n.sprite)
		}
		
		noteQueue.forEach{scroll(note:$0, time:time)}
		
		while let currFirst = noteQueue.first, time >= CGFloat(currFirst.startTime + 2.2) {
			let n = noteQueue.removeFirst()
			n.sprite.removeFromParent()
		}
	}
	
	private func scroll(note: TapNote, time: CGFloat) {
		let noteTime = time - note.startTime
		
		if noteTime > 2 {
			note.sprite.alpha = (2.1 - noteTime) * 10
			note.sprite.setScale(1.45 + (noteTime - 2)*15)
			return
		}
		
		switch note.type {
			case .red, .left:
				note.sprite.position = startPoint + transPoint(-noteTime*0.17, noteTime*0.425)
			case .green, .up:
				note.sprite.position = startPoint + transPoint(0, noteTime*0.425)
			case .blue, .right:
				note.sprite.position = startPoint + transPoint(noteTime*0.17, noteTime*0.425)
			default:
				break
		}
		
		note.sprite.setScale(noteTime/1.3)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for touch in touches {
			for i in 0...2 {
				if tapRect[i].contains(touch.location(in: view)) {
					glow.alpha = 1
					explosion[i].alpha = 1
					
					score += 150
					return
				}
			}
			if tapRect[3].contains(touch.location(in: view)) {
				pause()
				isPaused = true
				return
			}
		}
		score -= 70
	}
	
	private func updateGlow() {
		if glow.alpha > 0 {
			glow.alpha -= 0.05
		}
		
		explosion.forEach{
			if $0.alpha > 0 {
				$0.alpha -= 0.05
			}
		}
	}
}

