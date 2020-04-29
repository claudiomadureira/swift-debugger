//
//  iPod.swift
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

public enum iPod: String, CaseIterable {
    
    /// iPod touch (5th generation)
    case iPod5 = "iPod touch (5th generation)"
    
    /// iPod touch (6th generation)
    case iPod6 = "iPod touch (6th generation)"
    
    /// iPod touch (7th generation)
    case iPod7 = "iPod touch (7th generation)"
    
    case undefined
    
    public static var current: iPod {
        return self.current(for: Device.identifier)
    }
    
    static func current(for identifier: String) -> iPod {
        #if os(iOS)
        switch identifier {
        case "iPod5,1":
            return .iPod5
        case "iPod7,1":
            return .iPod6
        case "iPod9,1":
            return .iPod7
        default:
            break
        }
        #endif
        return .undefined
    }
    
}
