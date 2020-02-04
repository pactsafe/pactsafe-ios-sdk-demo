//
//  AppDelegate.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 9/26/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import UIKit
import Firebase
import PactSafe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        PSApp.shared.configure(siteAccessId: "790d7014-9806-4acc-8b8a-30c4987f3a95")
        
        PSApp.shared.preload(withGroupKey: "example-mobile-app-group")
        
        #if DEBUG
        // We're testing during development, so we'll set testMode to true. This should be removed before the app is ready for release.
        PSApp.shared.testMode = true
        
        // Set debugMode to true for debugPrint statements when things aren't working correctly.
        PSApp.shared.debugMode = true
        #endif
        
        FirebaseApp.configure()
        
        return true
    }


}

