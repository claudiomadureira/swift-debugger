//
//  SettingsView.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/25/20.
//

import UIKit
import SwiftArsenal

class SettingsView: UIView, NibLoadable {

    @IBOutlet private weak var textView: JSONWriterTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.text = Debug.stringfy(Debug.shared.localSettings)
    }

}
