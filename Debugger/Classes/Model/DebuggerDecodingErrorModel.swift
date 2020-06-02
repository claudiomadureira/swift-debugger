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
    var exampleJSONString: String { get }
}

struct DebuggerDecodingErrorModel: DebuggerErrorModel, Codable {
    
    var date: Date = Date()
    var type: LogType
    var exampleJSONString: String
    var modelName: String
    var description: String
    var detailedDescription: String
    var readableData: String
    
}
