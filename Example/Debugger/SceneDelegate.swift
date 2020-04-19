//
//  SceneDelegate.swift
//  Debugger-Example
//
//  Created by Claudio Madureira Silva Filho on 4/6/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import Debugger

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let scene = (scene as? UIWindowScene) else { return }
        self.launchApp(scene: scene)
    }
    
    private func launchApp(scene: UIWindowScene) {
        self.window = UIWindow(windowScene: scene)
        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.window?.makeKeyAndVisible()
        self.window?.attachDebugger()
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else { return }
        Debug.setUp(
            environments: kEnvironments,
            selectedEnvironmentAt: kEnvironments.firstIndex(where: { $0 == delegate.currentEnvironment }) ?? 0,
            localizations: kLocalizations,
            selectedLocalizationAt: kLocalizations.firstIndex(where: { $0 == delegate.currentLocalization }) ?? 0,
            showTextIdentifierOnLabels: false,
            eventHandler: { event in
                Debug.dismissSideMenu(animated: true, completion: {
                    switch event {
                    case .didChangeEnvironment(let environment):
                        delegate.currentEnvironment = environment
                        self.launchApp(scene: scene)
                        print("Did change environment to " + environment)
                    case .didChangeLocalization(let localization):
                        delegate.currentLocalization = localization
                        print("Did change localization to " + localization)
                    case .didSetLabelsTextIdentifierHidden(let hidden):
                        print("Labels identifier " + (hidden ? "hidden" : "showing"))
                    }
                })
        })
    }
    
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}
