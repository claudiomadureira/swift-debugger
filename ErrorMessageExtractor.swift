//
//  ErrorMessageExtractor.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 5/27/20.
//

import UIKit

enum ErrorMessageExtractor {

    static func description(from error: Error, modelName: String) -> String {
        switch error {
        case DecodingError.dataCorrupted(let context):
            return "[\(modelName)] " + context.debugDescription
        case DecodingError.typeMismatch(let value, let context):
            let text = context.debugDescription.components(separatedBy: " ")
            let expectedType = text[3]
            let foundType = text[7].capitalized
            return "[\(modelName)] expected <\(expectedType)> but found <\(foundType)> for \'\(context.codingPath.first?.stringValue ?? "")\'."
        case DecodingError.keyNotFound(let key, let context):
            return "[\(modelName)] key \'\(key.stringValue)\' not found."
            
        case DecodingError.valueNotFound(let value, let context):
            let parameterType = context.debugDescription.parameterType
            return "[\(modelName)] required <\(parameterType)> found null for \'\(context.codingPath.first?.stringValue ?? "")\'."
        default:
            break
        }
        return "Failed to decode \(modelName)."
    }
    
    static func detailedDescription(from error: Error) -> String {
        switch error {
        case DecodingError.keyNotFound(let key, let context):
            return key.stringValue
            
        case DecodingError.valueNotFound(let value, let context):
            return "[\(context.codingPath.first?.stringValue ?? "")] " + context.debugDescription
        default:
            return error.localizedDescription
        }
    }
    
}
