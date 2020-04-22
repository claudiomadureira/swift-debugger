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
        if let model = self.model as? DebuggerLogModel {
            return model.description
        }
        return ""
    }

}
