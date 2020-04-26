//
//  DebugDetailContentItemViewModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

class DebugDetailContentItemViewModel: DebugDetailItemViewModel {

    private let text: String
    private let shouldBreakLine: Bool
    
    required init(text: String, shouldBreakLine: Bool) {
        self.text = text
        self.shouldBreakLine = shouldBreakLine
    }
    
    func getText() -> String {
        return self.text
    }
    
    func getShouldBreakLine() -> Bool {
        return self.shouldBreakLine
    }
    
}
