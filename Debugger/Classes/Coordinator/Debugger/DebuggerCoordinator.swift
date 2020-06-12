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
        self.finish(animated: true, completion: nil)
    }
    
    func finish(animated: Bool, completion: (() -> Void)?) {
        let childCoordinator: LeftCoordinator? = self.logDetailCoordinator ?? self.togglesCoordinator
        if let childCoordinator = childCoordinator {
            childCoordinator.dismiss(completion: { [weak self] in
                self?.logDetailCoordinator = nil
                self?.togglesCoordinator = nil
                self?.finish(animated: true, completion: completion)
            })
            return
        }
        if animated {
            UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .calculationModeCubic, animations: {
                self.debuggerViewController?.setSideMenuAndShadow(hidden: true)
            }, completion: { [weak self] _ in
                self?.debuggerViewController?.dismiss(animated: false, completion: nil)
                DebuggerCoordinator.shared = nil
                completion?()
            })
        } else {
            self.debuggerViewController?.dismiss(animated: false, completion: nil)
            DebuggerCoordinator.shared = nil
        }
    }
    
}
