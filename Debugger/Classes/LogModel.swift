//
//  LogModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

struct LogModel: DebuggerLogModel, Codable {
    var description: String
    var type: LogType
    var date: Date = Date()
}
