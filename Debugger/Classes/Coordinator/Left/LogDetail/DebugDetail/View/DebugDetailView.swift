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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        self.textView.textColor = .white
    }
    
}
