//
//  DebuggerCoordinator.swift
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class DebuggerCoordinator: NSObject {

    static var shared: DebuggerCoordinator?
    
    let window: UIWindow
    
    weak var debuggerViewController: DebuggerViewController?
    
    required init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewController = DebuggerViewController()
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.events.on { (vc, event) in
            switch event {
            case .didDismiss:
                vc.dismiss(animated: false, completion: nil)
                DebuggerCoordinator.shared = nil
            }
        }
        self.window.rootViewController?.present(viewController, animated: false, completion: nil)
        self.debuggerViewController = viewController
    }
    
}
