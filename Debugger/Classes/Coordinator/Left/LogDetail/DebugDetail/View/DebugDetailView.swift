//
//  DebugDetailView.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/21/20.
//

import UIKit

class DebugDetailView: UIView, NibLoadable {

    @IBOutlet private weak var textView: UITextView!
    
    var text: String = "" {
        didSet {
            self.textView.text = self.text
        }
    }
    
}
