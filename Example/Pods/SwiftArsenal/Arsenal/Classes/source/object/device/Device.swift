//
//  Device.swift
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
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
            let identifier = self.simulatorIdentifier
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
    
    static var simulatorIdentifier: String {
        return ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"
    }
    
    static var correctIdentifier: String {
        return self.current == .simulator ? self.simulatorIdentifier : self.identifier
    }
    
}


/*
 
 This text is the StackOverFlow source code which will helps to update the current device each time that Apple launches a new one.
 The idea here to copy and paste eah time, check git status and add new models to respective enum.
 
 Thanks Apple for not offer this natively! ;)
 
 static let modelName: String = {
     var systemInfo = utsname()
     uname(&systemInfo)
     let machineMirror = Mirror(reflecting: systemInfo.machine)
     let identifier = machineMirror.children.reduce("") { identifier, element in
         guard let value = element.value as? Int8, value != 0 else { return identifier }
         return identifier + String(UnicodeScalar(UInt8(value)))
     }

     func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
         #if os(iOS)
         switch identifier {
         case "iPod5,1":                                 return "iPod touch (5th generation)"
         case "iPod7,1":                                 return "iPod touch (6th generation)"
         case "iPod9,1":                                 return "iPod touch (7th generation)"
         case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
         case "iPhone4,1":                               return "iPhone 4s"
         case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
         case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
         case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
         case "iPhone7,2":                               return "iPhone 6"
         case "iPhone7,1":                               return "iPhone 6 Plus"
         case "iPhone8,1":                               return "iPhone 6s"
         case "iPhone8,2":                               return "iPhone 6s Plus"
         case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
         case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
         case "iPhone8,4":                               return "iPhone SE"
         case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
         case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
         case "iPhone10,3", "iPhone10,6":                return "iPhone X"
         case "iPhone11,2":                              return "iPhone XS"
         case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
         case "iPhone11,8":                              return "iPhone XR"
         case "iPhone12,1":                              return "iPhone 11"
         case "iPhone12,3":                              return "iPhone 11 Pro"
         case "iPhone12,5":                              return "iPhone 11 Pro Max"
         case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
         case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad (3rd generation)"
         case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad (4th generation)"
         case "iPad6,11", "iPad6,12":                    return "iPad (5th generation)"
         case "iPad7,5", "iPad7,6":                      return "iPad (6th generation)"
         case "iPad7,11", "iPad7,12":                    return "iPad (7th generation)"
         case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
         case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
         case "iPad11,4", "iPad11,5":                    return "iPad Air (3rd generation)"
         case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad mini"
         case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad mini 2"
         case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad mini 3"
         case "iPad5,1", "iPad5,2":                      return "iPad mini 4"
         case "iPad11,1", "iPad11,2":                    return "iPad mini (5th generation)"
         case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
         case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
         case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
         case "iPad8,9", "iPad8,10":                     return "iPad Pro (11-inch) (2nd generation)"
         case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
         case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
         case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
         case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
         case "AppleTV5,3":                              return "Apple TV"
         case "AppleTV6,2":                              return "Apple TV 4K"
         case "AudioAccessory1,1":                       return "HomePod"
         case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
         default:                                        return identifier
         }
         #elseif os(tvOS)
         switch identifier {
         case "AppleTV5,3": return "Apple TV 4"
         case "AppleTV6,2": return "Apple TV 4K"
         case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
         default: return identifier
         }
         #endif
     }

     return mapToDevice(identifier: identifier)
 }()
 
 */
