//
//  DebuggerHTTPRequestModel.swift
//
//  Created by Claudio Madureira Silva Filho on 4/17/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

public protocol DebuggerHTTPRequestModel: DebuggerModel {
    var url: String { get }
    var method: String { get }
    var statusCode: Int { get }
    var headers: [String: String] { get }
    var body: Data { get }
    var responseBody: Data { get }
    var startDate: Date? { get }
    var duration: Int? { get } // in seconds
}
