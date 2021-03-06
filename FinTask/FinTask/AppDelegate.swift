//
//  AppDelegate.swift
//  FinTask
//
//  Created by Tomasz Pieczykolan on 05/06/2018.
//  Copyright © 2018 Tomasz Pieczykolan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    
    // MARK: - App lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = MainViewController()
        window?.tintColor = .defaultTint
        window?.makeKeyAndVisible()
        
        return true
    }
}
