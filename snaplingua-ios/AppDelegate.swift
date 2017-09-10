//
//  AppDelegate.swift
//  snaplingua-ios
//
//  Created by Samuel Drozdov on 9/9/17.
//  Copyright © 2017 SnapLingua. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    DLog(message: "AppWillResignActive")
    NotificationCenter.default.post(name: Notification.Name(AppNotification.AppWillResignActive), object: nil)
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    DLog(message: "AppDidEnterBackground")
    NotificationCenter.default.post(name: Notification.Name(AppNotification.AppDidEnterBackground), object: nil)
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    DLog(message: "AppWillEnterForeground")
    NotificationCenter.default.post(name: Notification.Name(AppNotification.AppWillEnterForeground), object: nil)
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    DLog(message: "AppDidBecomeActive")
    NotificationCenter.default.post(name: Notification.Name(AppNotification.AppDidBecomeActive), object: nil)
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    DLog(message: "AppDidBecomeActive")
    NotificationCenter.default.post(name: Notification.Name(AppNotification.AppDidBecomeActive), object: nil)
  }
}


