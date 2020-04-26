//
//  DebuggerHTTPRequestModel.swift
//
//  Created by Claudio Madureira Silva Filho on 4/17/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class DebuggerHTTPRequestCellViewModel: DebuggerItemViewModel {
    
    private let model: DebuggerHTTPRequestModel
    private let momentOfInstanciation: Date = Date()
    
    private var isResponseAnImage: Bool {
        return self.getImage() != nil
    }
    
    required init(model: DebuggerHTTPRequestModel) {
        self.model = model
    }
    
    func getTopText() -> String {
        if self.isResponseAnImage {
            return self.model.url
        }
        var result = self.model.url
            .replacingOccurrences(of: "https://", with: "")
            .replacingOccurrences(of: "http://", with: "")
        if let url = URL(string: self.model.url), let host = url.host {
            result = result.replacingOccurrences(of: host, with: "")
        }
        return result
    }
    
    func getMiddleText() -> String? {
        return self.isResponseAnImage ? self.getDurationText() : self.model.method.uppercased()
    }
    
    func getBottomRightText() -> String? {
        guard !self.isResponseAnImage else { return nil }
        return self.getDurationText()
    }
    
    func getImage() -> UIImage? {
        if let data = self.model.responseBody {
            return UIImage(data: data)
        }
        return nil
    }
    
    func getStatusCodeText() -> String {
        return String(self.model.statusCode)
    }
    
    func getStatusCodeColor() -> UIColor {
        return self.model.statusCode == 404 ? DebuggerViewConstants.redColor : DebuggerViewConstants.greenColor
    }
    
    func getDurationText() -> String? {
        guard let duration = self.model.duration else { return nil }
        return duration.readableDuration
    }
    
    func getStartedAtText() -> String? {
        guard let date = self.getStartAtDate() else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    private func getStartAtDate() -> Date? {
        if let startAt = self.model.startDate {
            return startAt
        }
        guard let duration = self.model.duration else { return nil }
        return self.momentOfInstanciation.addingTimeInterval(-TimeInterval(duration))
    }
    
}
