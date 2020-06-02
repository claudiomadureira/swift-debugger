//
//  DebugDetailViewModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/21/20.
//

import UIKit

protocol DebugDetailItemViewModel {
    func getText() -> String
}

class DebugDetailViewModel: NSObject {
    
    private let model: DebuggerModel
    
    private(set) var items: [DebugDetailItemViewModel] = []
    
    required init(model: DebuggerModel) {
        self.model = model
        
        // Table Content
        if let model = self.model as? DebuggerHTTPRequestModel {
            self.items.append(DebugDetailTitleItemViewModel(text: "URL:"))
            self.items.append(DebugDetailContentItemViewModel(text: model.url, shouldBreakLine: true))
            self.items.append(DebugDetailTitleItemViewModel(text: "Method:"))
            self.items.append(DebugDetailContentItemViewModel(text: model.method.uppercased(), shouldBreakLine: true))
            self.items.append(DebugDetailTitleItemViewModel(text: "Headers:"))
            let headersText = Debug.stringfy(model.headers)
            self.items.append(DebugDetailContentItemViewModel(text: headersText, shouldBreakLine: false))
            self.items.append(DebugDetailTitleItemViewModel(text: "Parameters:"))
            let bodyText = Debug.stringfy(model.body)
            self.items.append(DebugDetailContentItemViewModel(text: bodyText, shouldBreakLine: false))
            self.items.append(DebugDetailTitleItemViewModel(text: "Status code:"))
            self.items.append(DebugDetailContentItemViewModel(text: String(model.statusCode), shouldBreakLine: true))
            self.items.append(DebugDetailTitleItemViewModel(text: "Response body:"))
            let responseBodyText = Debug.stringfy(model.responseBody)
            self.items.append(DebugDetailContentItemViewModel(text: responseBodyText, shouldBreakLine: false))
        }
        if let model = self.model as? DebuggerErrorModel {
            self.items.append(DebugDetailTitleItemViewModel(text: "Description:"))
            let descriptionText = model.description
                .replacingOccurrences(of: "[\(model.modelName)] ", with: "")
            self.items.append(DebugDetailContentItemViewModel(text: descriptionText, shouldBreakLine: true))
            self.items.append(DebugDetailTitleItemViewModel(text: "Data attempted to decode:"))
            self.items.append(DebugDetailContentItemViewModel(text: model.readableData, shouldBreakLine: false))
            self.items.append(DebugDetailTitleItemViewModel(text: "Auto-generated acceptable example based on data used:"))
            self.items.append(DebugDetailContentItemViewModel(text: model.exampleJSONString, shouldBreakLine: false))
        }
    }
    
    func getIsTableContent() -> Bool {
        return (self.model is DebuggerHTTPRequestModel) ||
            (self.model is DebuggerErrorModel)
    }
    
    func getText() -> NSAttributedString {
        let text = NSMutableAttributedString()
        if self.model is DebuggerErrorModel {
            return text
        }
        let fontSize: CGFloat = 18
        let color: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: UIFont.boldSystemFont(ofSize: fontSize)
        ]
        let valueAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: fontSize)
        ]
        if let model = self.model as? DebuggerLogModel {
            let description = NSAttributedString(string: model.description, attributes: valueAttributes)
            text.append(description)
            return text
        }
        return text
    }
    
    var title: String {
        if let model = self.model as? LogModel {
            return model.type.rawValue
        }
        if let model = self.model as? DebuggerErrorModel {
            return model.modelName
        }
        if let model = self.model as? DebuggerHTTPRequestModel {
            let viewModel = DebuggerHTTPRequestCellViewModel(model: model)
            return viewModel.getTopText()
        }
        return ""
    }
    
    func getBottomText() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let model = self.model as? DebuggerLogModel {
            return formatter.string(from: model.date)
        }
        if let model = self.model as? DebuggerHTTPRequestModel,
            let date = model.startDate {
            var text = "started at " + formatter.string(from: date)
            if let duration = model.duration {
                text.append(" and last " + duration.readableDuration)
            }
            return text
        }
        return "-"
    }

}
