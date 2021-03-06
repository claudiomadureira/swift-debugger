//
//  LogType.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/25/20.
//

import UIKit

enum LogType: String, Codable {
    case error = "Error"
    case warning = "Warning"
    case print = "Print"
    case success = "Success"
    case decodingError = "Decoded"
    
    var emoji: Emoji {
        switch self {
        case .error:
            return .error
        case .warning:
            return .warning
        case .print:
            return .print
        case .success:
            return .success
        case .decodingError:
            return .bug
        }
    }
    
    var printTag: String {
        let emoji = self.emoji.rawValue
        switch self {
        case .error, .print:
            return "\(emoji) \(self.rawValue)   => "
        default:
            return "\(emoji) \(self.rawValue) => "
        }
    }
    
    var debuggerColor: UIColor {
        switch self {
        case .error, .decodingError:
            return DebuggerViewConstants.redColor
        case .warning:
            return DebuggerViewConstants.yellowColor
        case .print:
            return .white
        case .success:
            return DebuggerViewConstants.greenColor
        }
    }
    
}
