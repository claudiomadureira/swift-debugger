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

struct DebuggerDecodingErrorModel: DebuggerErrorModel {
    
    let data: Data
    var date: Date = Date()
    var type: LogType
    var example: [String : Any]
    var modelName: String
    var description: String
    var detailedDescription: String
    
    var readableData: String {
        return Debug.stringfy(self.data)
    }
    
}
