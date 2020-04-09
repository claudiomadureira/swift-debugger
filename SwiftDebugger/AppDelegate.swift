//
//  AppDelegate.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/6/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.launchApp()
        return true
    }
    
    func launchApp() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
        self.window?.attachDebugger()
        Debugger.shared.setUp(
            environments: ["DEBUG", "RELEASE"],
            localizations: ["en_US", "pt_BR"],
            showTextIdentifierOnLabels: false,
            eventHandler: { event in
                switch event {
                case .didChangeEnvironment(let environment):
                    self.launchApp()
                    print("Did change environment to " + environment)
                case .didChangeLocalization(let localization):
                    print("Did change localization to " + localization)
                case .didSetLabelsTextIdentifierHidden(let hidden):
                    print("Labels identifier " + (hidden ? "hidden" : "showing"))
                }
        })
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

