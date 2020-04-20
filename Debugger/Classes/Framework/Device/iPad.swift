//
//  iPad.swift
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

public enum iPad: String, CaseIterable {
    
    /// iPad 2
    case iPad2 = "iPad 2"
    
    /// iPad (3rd generation)
    case iPad_3rd = "iPad (3rd generation)"
    
    /// iPad (4th generation)
    case iPad_4th = "iPad (4th generation)"
    
    /// iPad (5th generation)
    case iPad_5th = "iPad (5th generation)"
    
    /// iPad (6th generation)
    case iPad_6th = "iPad (6th generation)"
    
    /// iPad (7th generation)
    case iPad_7th = "iPad (7th generation)"
    
    /// iPad Air
    case iPadAir = "iPad Air"
    
    /// iPad Air 2
    case iPadAir2 = "iPad Air 2"
    
    /// iPad Air (3rd generation)
    case iPadAir_3rd = "iPad Air (3rd generation)"
    
    /// iPad mini
    case iPadMini = "iPad mini"
    
    /// iPad mini 2
    case iPadMini2 = "iPad mini 2"
    
    /// iPad mini 3
    case iPadMini3 = "iPad mini 3"
    
    /// iPad mini 4
    case iPadMini4 = "iPad mini 4"
    
    /// iPad mini (5th generation)
    case iPadMini5 = "iPad mini (5th generation)"
    
    /// iPad Pro (9.7-inch)
    case iPadPro97inch = "iPad Pro (9.7-inch)"
    
    /// iPad Pro (10.5-inch)
    case iPadPro105inch = "iPad Pro (10.5-inch)"
    
    /// iPad Pro (11-inch)
    case iPadPro11inch = "iPad Pro (11-inch)"
    
    /// iPad Pro (11-inch) (2nd generation)
    case iPadPro11inch_2nd = "iPad Pro (11-inch) (2nd generation)"
    
    /// iPad Pro (12.9-inch)
    case iPadPro129inch = "iPad Pro (12.9-inch)"
    
    /// iPad Pro (12.9-inch) (2nd generation)
    case iPadPro129inch_2nd = "iPad Pro (12.9-inch) (2nd generation)"
    
    /// iPad Pro (12.9-inch) (3rd generation)
    case iPadPro129inch_3rd = "iPad Pro (12.9-inch) (3rd generation)"
    
    /// iPad Pro (12.9-inch) (4th generation)
    case iPadPro129inch_4th = "iPad Pro (12.9-inch) (4th generation)"
    
    case undefined
    
    public static var current: iPad {
        return self.current(for: Device.identifier)
    }
    
    static func current(for identifier: String) -> iPad {
        #if os(iOS)
        switch identifier {
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
            return .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":
            return .iPad_3rd
        case "iPad3,4", "iPad3,5", "iPad3,6":
            return .iPad_4th
        case "iPad6,11", "iPad6,12":
            return .iPad_5th
        case "iPad7,5", "iPad7,6":
            return .iPad_6th
        case "iPad7,11", "iPad7,12":
            return .iPad_7th
        case "iPad4,1", "iPad4,2", "iPad4,3":
            return .iPadAir
        case "iPad5,3", "iPad5,4":
            return .iPadAir2
        case "iPad11,4", "iPad11,5":
            return .iPadAir_3rd
        case "iPad2,5", "iPad2,6", "iPad2,7":
            return .iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":
            return .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":
            return .iPadMini3
        case "iPad5,1", "iPad5,2":
            return .iPadMini4
        case "iPad11,1", "iPad11,2":
            return .iPadMini5
        case "iPad6,3", "iPad6,4":
            return .iPadPro97inch
        case "iPad7,3", "iPad7,4":
            return .iPadPro105inch
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":
            return .iPadPro11inch
        case "iPad8,9", "iPad8,10":
            return .iPadPro11inch_2nd
        case "iPad6,7", "iPad6,8":
            return .iPadPro129inch
        case "iPad7,1", "iPad7,2":
            return .iPadPro129inch_2nd
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":
            return .iPadPro129inch_3rd
        case "iPad8,11", "iPad8,12":
            return .iPadPro129inch_4th
        default:
            break
        }
        #endif
        return .undefined
    }
    
}
