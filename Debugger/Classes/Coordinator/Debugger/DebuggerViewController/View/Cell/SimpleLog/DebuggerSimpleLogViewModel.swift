//
//  DebuggerSimpleLogModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

class DebuggerSimpleLogViewModel: DebuggerItemViewModel {
    
    let model: DebuggerLogModel
    
    required init(model: DebuggerLogModel) {
        self.model = model
    }
    
    func logTopText() -> String {
        return self.model.description
    }
    
    func logTopTextColor() -> UIColor {
        return self.model.textColor
    }
    
    func dateBottomText() -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self.model.date)
    }
    
}


