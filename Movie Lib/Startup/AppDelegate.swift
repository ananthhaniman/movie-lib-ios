//
//  AppDelegate.swift
//  Movie Lib
//
//  Created by Ananthamoorthy Haniman on 2022-05-22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let windowScene = UIWindow(frame: UIScreen.main.bounds)
        windowScene.rootViewController = MainVC()
        windowScene.makeKeyAndVisible()
        
        self.window = windowScene
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    /// `applicationWillTerminate` - during the termination of the application this funtion will get trigger
    func applicationWillTerminate(_ application: UIApplication) {
        // So i logged the last accessed time stamp.
        AppLog.shared.log()
    }
    
    
}

