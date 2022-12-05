//
//  AppDelegate.swift
//  PactSafe iOS Demo
//
//  Created by Tim Morse  on 9/26/19.
//  Copyright © 2019 Tim Morse . All rights reserved.
//

import PactSafe
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  // Example getting values from PLIST file. There are better ways of doing this.
  var psSiteAccessId: String?
  var psGroupKey: String?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Get your Ironclad Clickwrap Site Access ID.
    // For demo purposes only and production implementations will likely look different.
    var nsDictionary: NSDictionary?
    // Change PLIST file name if you'd like to use the configuration here.
    if let path = Bundle.main.path(forResource: "PactSafe-Configuration", ofType: "plist") {
      nsDictionary = NSDictionary(contentsOfFile: path)
      psSiteAccessId = nsDictionary?.value(forKey: "PACTSAFE_ACCESS_ID") as? String
      psGroupKey = nsDictionary?.value(forKey: "PACTSAFE_GROUP_KEY") as? String
    }

    // Please avoid force unwrapping in production, this is only for
    // demo purposes and to avoid additional boilderplace code :)
    PSApp.shared.configure(siteAccessId: psSiteAccessId!)

    PSApp.shared.preload(withGroupKey: psGroupKey!)

    #if DEBUG
      // We're testing during development, so we'll set testMode to true. This should be removed before the app is ready for release.
      PSApp.shared.testMode = true

      // Set debugMode to true for debugPrint statements when things aren't working correctly.
      PSApp.shared.debugMode = true
    #endif

    return true
  }
}
