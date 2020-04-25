//
//  DebuggerCoordinator.swift
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class DebuggerCoordinator: Coordinator {
    
    static var shared: DebuggerCoordinator?
    
    let window: UIWindow
    
    weak var debuggerViewController: DebuggerViewController?
    var togglesCoordinator: SettingsCoordinator?
    var logDetailCoordinator: LogDetailCoordinator?
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewController = DebuggerViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.events.on { [weak self] (vc, event) in
            switch event {
            case .didPressToDetailAt(let index):
                vc.animateSideMenu(hidden: true, animated: true, completion: nil)
                self?.logDetailCoordinator = LogDetailCoordinator(rootViewController: vc, index: index)
                self?.logDetailCoordinator?.events.on({ [weak self] (coordinator, event) in
                    switch event {
                    case .didPanToDismissToggles(let progress):
                        self?.debuggerViewController?.setSideMenuHidden(progress: 1 - progress)
                    case .didFinish:
                        self?.logDetailCoordinator = nil
                    case .dismiss:
                        self?.debuggerViewController?.animateSideMenu(hidden: false, animated: true, completion: nil)
                    }
                })
                self?.logDetailCoordinator?.start()
                
            case .didPressToSeeToggles:
                vc.animateSideMenu(hidden: true, animated: true, completion: nil)
                self?.togglesCoordinator = SettingsCoordinator(rootViewController: vc)
                self?.togglesCoordinator?.events.on({ [weak self] (coordinator, event) in
                    switch event {
                    case .didPanToDismissToggles(let progress):
                        self?.debuggerViewController?.setSideMenuHidden(progress: 1 - progress)
                        
                    case .didFinish:
                        self?.togglesCoordinator = nil
                    case .dismiss:
                        self?.debuggerViewController?.animateSideMenu(hidden: false, animated: true, completion: nil)
                    }
                })
                self?.togglesCoordinator?.start()
            case .didDismiss:
                vc.dismiss(animated: false, completion: nil)
                DebuggerCoordinator.shared = nil
            }
        }
        self.window.rootViewController?.present(viewController, animated: false, completion: nil)
        self.debuggerViewController = viewController
    }
    
    func finish() {
        
    }
    
}
