//
//  DebuggerErrorModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

protocol DebuggerErrorModel: DebuggerLogModel {
    var modelName: String { get }
    var readableData: String { get }
    var example: [String: Any] { get }
}

struct DebuggerDecodingErrorModel<Model: Decodable>: DebuggerErrorModel {
    
    let error: Error
    let model: Model.Type
    let data: Data
    var date: Date = Date()
    var type: LogType
    var example: [String : Any]
    
    var modelName: String {
        return "\(self.model)"
    }
    
    var description: String {
        switch self.error {
        case DecodingError.dataCorrupted(let context):
            return "[\(self.model)] " + context.debugDescription
        case DecodingError.typeMismatch(let value, let context):
            let text = context.debugDescription.components(separatedBy: " ")
            let expectedType = text[3]
            let foundType = text[7].capitalized
            return "[\(self.model)] expected <\(expectedType)> but found <\(foundType)> for \'\(context.codingPath.first?.stringValue ?? "")\'."
        case DecodingError.keyNotFound(let key, let context):
            return "[\(self.model)] key \'\(key.stringValue)\' not found."
            
        case DecodingError.valueNotFound(let value, let context):
            let parameterType = context.debugDescription.parameterType
            return "[\(self.model)] required <\(parameterType)> found null for \'\(context.codingPath.first?.stringValue ?? "")\'."
        default:
            break
        }
        return "Failed to decode \(self.model)."
    }
    
    var detailedDescription: String {
        switch self.error {
        case DecodingError.keyNotFound(let key, let context):
            return key.stringValue
            
        case DecodingError.valueNotFound(let value, let context):
            return "[\(context.codingPath.first?.stringValue ?? "")] " + context.debugDescription
        default:
            return self.error.localizedDescription
        }
    }
    
    var textColor: UIColor {
        return self.type.debuggerColor
    }
    
    var readableData: String {
        return Debug.stringfy(self.data)
    }
    
}
