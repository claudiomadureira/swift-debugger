//
//  InitialTouchPanGestureRecognizer.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/8/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class InitialTouchPanGestureRecognizer: UIPanGestureRecognizer {
    
    var initialTouchLocation: CGPoint?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        self.initialTouchLocation = touches.first?.location(in: view)
    }
    
}

