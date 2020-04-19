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
        return UIImage(data: self.model.responseBody)
    }
    
    func getStatusCodeText() -> String {
        return String(self.model.statusCode)
    }
    
    func getStatusCodeColor() -> UIColor {
        return self.model.statusCode == 404 ? #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1) : #colorLiteral(red: 0.1990376711, green: 0.7803677917, blue: 0.3488332629, alpha: 1)
    }
    
    func getDurationText() -> String? {
        guard let duration = self.model.duration else { return nil }
        if duration > 120 {
            let minutes = duration/60
            let rest = duration - 60*Int(Double(duration)/60.0)
            var text = String(minutes) + "m"
            if rest > 0 {
                text.append(" " + String(rest) + "s")
            }
            return text
        }
        return String(duration) + "s"
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
