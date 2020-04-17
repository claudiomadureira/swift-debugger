//
//  Extension-UIWindow.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/13/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
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
        guard sender.state == .began else { return }
        let view = DebuggerView.xib()
        view.frame = .init(origin: .zero, size: UIScreen.main.bounds.size)
        self.addSubview(view)
        view.appearInAnimated()
        DebuggerView.shared = view
    }
    
}


