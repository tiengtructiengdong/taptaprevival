//
//  AppDelegate.swift
//  ttrsdk
//
//  Created by Gióng Làng on 18/06/2021.
//

import UIKit

@main
// Remove that key in info.plist

class AppDelegate: UIResponder, UIApplicationDelegate {
	
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = ScreenController(nibName: "ScreenView", bundle: nil)
		window?.makeKeyAndVisible()
		return true
	}
	
	
	
}

