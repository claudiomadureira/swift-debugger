//
//  Extension-UIWindow.swift
//
//  Created by Claudio Madureira Silva Filho on 4/13/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit


extension UIWindow {
    
    public func attachDebugger() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongTouch))
        gesture.minimumPressDuration = 2
        gesture.delaysTouchesEnded = false
        gesture.allowableMovement = 30
        self.addGestureRecognizer(gesture)
    }
    
    @objc
    private func onLongTouch(_ sender: UILongPressGestureRecognizer) {
        guard DebuggerCoordinator.shared == nil, sender.state == .began else { return }
        DebuggerCoordinator.shared = DebuggerCoordinator(window: self)
        DebuggerCoordinator.shared?.start()
    }
    
}


