//
//  DebugDetailTitleItemViewModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

class DebugDetailTitleItemViewModel: DebugDetailItemViewModel {
    
    private let text: String
    
    required init(text: String) {
        self.text = text
    }
    
    func getText() -> String {
        return self.text
    }
    
}
