//
//  Listener.swift
//
//  Created by Claudio Madureira on 21/11/19.
//

import UIKit

public class Listener<Value>: NSObject {

    public typealias Handler = (Value) -> Void
    
    private let handler: Handler
    
    public required init(handler: @escaping Handler) {
        self.handler = handler
    }
    
    public func emit(_ value: Value) {
        self.handler(value)
    }
    
}
