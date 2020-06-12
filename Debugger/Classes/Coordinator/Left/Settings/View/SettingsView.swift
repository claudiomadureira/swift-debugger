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

    var viewModel: SettingsViewModel = .init() {
        didSet {
            self.textView.text = self.viewModel.getSettingsText()
        }
    }
    
    var text: String? {
        return self.textView.text
    }
    
    private var onJSONTextChanged: ((SettingsView) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textView.onTextDidChange { [weak self] (texView) in
            guard let self = self else { return }
            self.onJSONTextChanged?(self)
        }
    }
    
    func onJSONTextChanged(handler: @escaping (SettingsView) -> Void) {
        self.onJSONTextChanged = handler
    }

}
