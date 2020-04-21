//
//  DebuggerErrorModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

struct DebuggerDecodingErrorModel<Model: Decodable>: DebuggerLogModel {
    let error: Error
    let model: Model.Type
    let data: Data
    var date: Date = Date()
    
    var shortDescription: String {
        return "Failed to decode <\(self.model)>."
    }
    
    var detailedDescription: String {
        print("\(self.error)")
        switch self.error {
        case DecodingError.keyNotFound(let key, let context):
            print("Context: ", context)
            return key.stringValue
            
        case DecodingError.valueNotFound(let value, let context):
            print("Context: ", context)
            print("Value: ", value)
            return "[\(context.codingPath.first?.stringValue ?? "")] " + context.debugDescription
        default:
            return self.error.localizedDescription
        }
    }
    
    var textColor: UIColor {
        return DebuggerViewConstants.redColor
    }

}
