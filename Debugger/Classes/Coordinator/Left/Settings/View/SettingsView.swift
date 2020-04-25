//
//  SettingsView.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/25/20.
//

import UIKit

class SettingsView: UIView, NibLoadable {

    @IBOutlet private weak var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.text = Debug.stringfy(Debug.localSettings)
    }

}