//
//  Signal.swift
//
//  Created by Claudio Madureira Silva Filho on 6/20/19.
//  Copyright © 2019. All rights reserved.
//

import UIKit

public class Signal<Type>: NSObject {
    
    public typealias EventHandler = (Type) -> Void
    
    private var handler: EventHandler?
    
    public func emit(_ event: Type) {
        self.handler?(event)
    }
    
    public func on(_ eventHandler: @escaping EventHandler) {
        self.handler = eventHandler
    }
    
}
