//
//  AppleTV.swift
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

public enum AppleTV: String, CaseIterable {
    case normal = "Apple TV"
    case with4k = "Apple TV 4k"
    case undefined
    
    public static var current: AppleTV {
        return self.current(for: Device.identifier)
    }
    
    static func current(for identifier: String) -> AppleTV {
        switch identifier {
        case "AppleTV5,3":
            return .normal
        case "AppleTV6,2":
            return .with4k
        default:
            break
        }
        return .undefined
    }
    
}
