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
        
        // Set authentication before use
        PSApp.shared.authentication = PSAuthentication(accessToken: "***REMOVED***", siteAccessId: "***REMOVED***")
        
        // We're testing during development, so we'll set testMode to true. This should be removed before the app is ready for release.
        PSApp.shared.testMode = true
        
        // Set debugMode to true for debugPrint statements when things aren't working correctly.
        PSApp.shared.debugMode = true
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

