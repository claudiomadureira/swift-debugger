//
//  DebuggerHTTPRequestModel.swift
//
//  Created by Claudio Madureira Silva Filho on 4/17/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

public protocol DebuggerHTTPRequestModel: DebuggerModel, Codable {
    var url: String { get }
    var method: String { get }
    var statusCode: Int { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var responseBody: Data? { get }
    var startDate: Date? { get }
    var duration: Int? { get } // in seconds
}

struct DebuggerHTTPRequest: DebuggerHTTPRequestModel {
    
    static func from(model: DebuggerHTTPRequestModel) -> DebuggerHTTPRequest {
        return DebuggerHTTPRequest(
            date: model.date,
            url: model.url,
            method: model.method,
            statusCode: model.statusCode,
            headers: model.headers,
            body: model.body,
            responseBody: model.responseBody,
            startDate: model.startDate,
            duration: model.duration)
    }
    
    var date: Date
    var url: String
    var method: String
    var statusCode: Int
    var headers: [String: String]?
    var body: Data?
    var responseBody: Data?
    var startDate: Date?
    var duration: Int?
}
