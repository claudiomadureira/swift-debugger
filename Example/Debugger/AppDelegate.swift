//
//  AppDelegate.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/6/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import Debugger

let kEnvironments = ["DEBUG", "RELEASE"]
//let kEnvironments = [String]()
//let kLocalizations = ["en_US", "pt_BR", "es_MX"]
let kLocalizations = [String]()

extension Debug {
    
    static func setUp() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        Debug.environments = kEnvironments
        Debug.indexSelectedEnvironment = kEnvironments.firstIndex(where: { $0 == delegate.currentEnvironment }) ?? 0
        Debug.localizations = kLocalizations
        Debug.indexSelectedLocalization = kLocalizations.firstIndex(where: { $0 == delegate.currentLocalization }) ?? 0
        Debug.isVisibleIdentifier = true
        Debug.localSettings = [
            "dateFormat": "yyyy-MM-dd",
            "isLoginFacebookEnabled": true,
        ]
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var currentEnvironment: String = "DEBUG"
    var currentLocalization: String = "en_US"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard #available(iOS 13.0, *) else {
            self.launchApp()
            return true
        }
        return true
    }
    
    func launchApp() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
        self.window?.attachDebugger()
        Debug.setUp()
        Debug.events.on { event in
            Debug.dismissSideMenu(animated: true, completion: {
                switch event {
                case .didChangeEnvironment(let environment):
                    self.currentEnvironment = environment
                    self.launchApp()
                    print("Did change environment to " + environment)
                case .didChangeLocalization(let localization):
                    print("Did change localization to " + localization)
                    self.currentLocalization = localization
                case .didChangeIdentifierVisibility(let hidden):
                    print("Labels identifier " + (hidden ? "hidden" : "showing"))
                case .didChangeLocalSettings(let settings):
                    print("Settings:\n" + Debug.stringfy(settings))
                }
            })
        }
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


}

