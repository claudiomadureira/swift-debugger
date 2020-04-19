//
//  ListenerManager.swift
//
//  Created by Claudio Madureira on 22/11/19.
//

import UIKit

/// The listener manager has an odd feature which it unbinds the listener that was deallocated from memory.
/// This is the ListenerMemoryManagerWrapper's goal.
open class ListenerManager<ListenerValue> {
    
    public typealias CustomListener = Listener<ListenerValue>
    
    class ListenerMemoryManagedWrapper: NSObject {
        weak var listener: CustomListener?
    }
    
    var memoryManagedListeners: Set<ListenerMemoryManagedWrapper> = .init()
    
    public init() {
        
    }
    
    /// Bind the listener in the manager.
    ///
    /// - Returns: If it succeded to bind the listener.
    @discardableResult
    public func bind(_ listener: CustomListener) -> Bool {
        for memoryManagedListener in self.memoryManagedListeners {
            if memoryManagedListener.listener == listener {
                return false
            }
        }
        let memoryManagedListener: ListenerMemoryManagedWrapper = .init()
        memoryManagedListener.listener = listener
        self.memoryManagedListeners.insert(memoryManagedListener)
        return true
    }
    
    /// Unbind the listener in the manager.
    ///
    /// - Returns: If it succeded to unbind the listener.
    @discardableResult
    public func unbind(_ listener: CustomListener) -> Bool {
        for memoryManagedListener in self.memoryManagedListeners {
            if memoryManagedListener.listener == listener {
                self.memoryManagedListeners.remove(memoryManagedListener)
                return true
            }
        }
        return false
    }
    
    public func emit(_ value: ListenerValue) {
        for memoryManagedListener in self.memoryManagedListeners {
            if let listener = memoryManagedListener.listener {
                listener.emit(value)
            } else {
                self.memoryManagedListeners.remove(memoryManagedListener)
            }
        }
    }
    
}
