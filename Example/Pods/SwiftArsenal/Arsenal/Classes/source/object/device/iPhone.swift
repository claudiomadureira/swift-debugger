//
//  iPhone.swift
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

public enum iPhone: String, CaseIterable {
    case iPhone4 = "iPhone 4"
    case iPhone4s = "iPhone 4s"
    case iPhone5 = "iPhone 5"
    case iPhone5c = "iPhone 5c"
    case iPhone5s = "iPhone 5s"
    case iPhone6 = "iPhone 6"
    case iPhone6Plus = "iPhone 6 Plus"
    case iPhone6s = "iPhone 6s"
    case iPhone6sPlus = "iPhone 6s Plus"
    case iPhone7 = "iPhone 7"
    case iPhone7Plus = "iPhone 7 Plus"
    case iPhoneSE = "iPhone SE"
    case iPhone8 = "iPhone 8"
    case iPhone8Plus = "iPhone 8 Plus"
    case iPhoneX = "iPhone X"
    case iPhoneXS = "iPhone XS"
    case iPhoneXSMax = "iPhone XS Max"
    case iPhoneXR = "iPhone XR"
    case iPhone11 = "iPhone 11"
    case iPhone11Pro = "iPhone 11 Pro"
    case iPhone11ProMax = "iPhone 11 Pro Max"
    case undefined
    
    public var isInfiniteScreen: Bool {
        switch self {
        case .iPhoneX,
             .iPhoneXR,
             .iPhoneXS,
             .iPhoneXSMax,
             .iPhone11,
             .iPhone11Pro,
             .iPhone11ProMax:
            return true
        default:
            return false
        }
    }
    
    public static var current: iPhone {
        return self.current(for: Device.identifier)
    }
    
    static func current(for identifier: String) -> iPhone {
        #if os(iOS)
        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":
            return .iPhone4
        case "iPhone4,1":
            return .iPhone4s
        case "iPhone5,1", "iPhone5,2":
            return .iPhone5
        case "iPhone5,3", "iPhone5,4":
            return .iPhone5c
        case "iPhone6,1", "iPhone6,2":
            return .iPhone5s
        case "iPhone7,2":
            return .iPhone6
        case "iPhone7,1":
            return .iPhone6Plus
        case "iPhone8,1":
            return .iPhone6s
        case "iPhone8,2":
            return .iPhone6sPlus
        case "iPhone9,1", "iPhone9,3":
            return .iPhone7
        case "iPhone9,2", "iPhone9,4":
            return .iPhone7Plus
        case "iPhone8,4":
            return .iPhoneSE
        case "iPhone10,1", "iPhone10,4":
            return .iPhone8
        case "iPhone10,2", "iPhone10,5":
            return .iPhone8Plus
        case "iPhone10,3", "iPhone10,6":
            return .iPhoneX
        case "iPhone11,2":
            return .iPhoneXS
        case "iPhone11,4", "iPhone11,6":
            return .iPhoneXSMax
        case "iPhone11,8":
            return .iPhoneXR
        case "iPhone12,1":
            return .iPhone11
        case "iPhone12,3":
            return .iPhone11Pro
        case "iPhone12,5":
            return .iPhone11ProMax
        default:
            break
        }
        #endif
        return .undefined
    }
    
}
