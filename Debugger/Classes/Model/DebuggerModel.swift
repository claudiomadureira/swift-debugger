//
//  DebuggerModel.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/17/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

public protocol DebuggerModel: Codable {
    var date: Date { get }
}

