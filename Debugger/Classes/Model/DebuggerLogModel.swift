//
//  DebuggerLogModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

protocol DebuggerLogModel: DebuggerModel {
    var description: String { get }
    var type: LogType { get }
}
