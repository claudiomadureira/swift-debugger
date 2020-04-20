//
//  Device.swift
//  SwiftArsenal
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

public enum Device: String, CaseIterable {
    case iphone = "iPhone"
    case ipod = "iPod"
    case ipad = "iPad"
    case appleTV = "Apple TV"
    case homePod = "HomePod"
    case simulator = "Simulator"
    case undefined
    
    public static var current: Device {
        return self.current(for: self.identifier)
    }
    
    public static var specificName: String {
        let undefined = "undefined"
        switch self.current {
        case .iphone:
            return iPhone.current.rawValue
        case .ipod:
            return iPod.current.rawValue
        case .ipad:
            return iPad.current.rawValue
        case .appleTV:
            return AppleTV.current.rawValue
        case .homePod:
            return Device.homePod.rawValue
        case .simulator:
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"
            let device = self.current(for: identifier)
            var name: String = "Simulator "
            switch device {
            case .iphone:
                name.append(iPhone.current(for: identifier).rawValue)
            case .ipod:
                name.append(iPod.current(for: identifier).rawValue)
            case .ipad:
                name.append(iPad.current(for: identifier).rawValue)
            case .appleTV:
                name.append(AppleTV.current(for: identifier).rawValue)
            case .homePod:
                name.append(Device.homePod.rawValue)
            default:
                return undefined
            }
            return name
        default:
            return undefined
        }
    }
    
    static func current(for identifier: String) -> Device {
        #if os(iOS)
        switch identifier {
        case "AudioAccessory1,1":
            return .homePod
        case "i386", "x86_64":
            return .simulator
        default:
            break
        }
        if iPhone.current(for: identifier) != .undefined {
            return .iphone
        }
        if iPod.current(for: identifier) != .undefined {
            return .ipod
        }
        if iPad.current(for: identifier) != .undefined {
            return .ipad
        }
        #endif
        if AppleTV.current(for: identifier) != .undefined {
            return .appleTV
        }
        return .undefined
    }
    
    static var identifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
}
