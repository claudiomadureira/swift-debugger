//
//  ExampleHTTPResquest.swift
//  Debugger-Example
//
//  Created by Claudio Madureira Silva Filho on 4/17/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import Debugger

struct ExampleHTTPResquest: DebuggerHTTPRequestModel {
    
    var url: String
    
    var method: String
    
    var statusCode: Int
    
    var headers: [String : String]?
    
    var body: Data?
    
    var responseBody: Data?
    
    var startDate: Date?
    
    var duration: Int?
    
}
