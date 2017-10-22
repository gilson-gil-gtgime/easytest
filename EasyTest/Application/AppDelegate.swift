//
//  AppDelegate.swift
//  EasyTest
//
//  Created by Gilson Gil on 19/10/17.
//  Copyright © 2017 Gilson Gil. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    ProgressHUD.setUp()
    
    let frame = UIScreen.main.bounds
    window = UIWindow(frame: frame)
    window?.makeKeyAndVisible()
    window?.rootViewController = MapViewController()
    return true
  }
}
