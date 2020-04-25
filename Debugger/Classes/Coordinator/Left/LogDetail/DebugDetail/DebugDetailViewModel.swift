//
//  DebugDetailViewModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/21/20.
//

import UIKit

class DebugDetailViewModel: NSObject {
    
    private let model: DebuggerModel
    
    required init(model: DebuggerModel) {
        self.model = model
    }
    
    var text: String {
        if let model = self.model as? DebuggerErrorModel {
            return ("Description: \n\n" + model.description + "\n\nInput data:\n\n" + model.readableData)
                .replacingOccurrences(of: "[\(model.modelName)] ", with: "")
        }
        if let model = self.model as? DebuggerLogModel {
            return model.description
        }
        return ""
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

}
