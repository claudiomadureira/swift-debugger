//
//  JSONWriterToolbarView.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 6/8/20.
//

import UIKit
import SwiftArsenal

class JSONWriterToolbarView: UIView, NibLoadable {
    
    typealias Event = (JSONWriterToolbarView) -> Void
    
    @IBOutlet private weak var viewContainer: UIView!
    @IBOutlet private weak var lblJSON: UILabel!
    @IBOutlet private weak var lblStatus: UILabel!
    @IBOutlet private weak var btnDone: Button!
    @IBOutlet private weak var btnQuotationMarks: Button!
    @IBOutlet private weak var btnJSONEmpty: Button!
    @IBOutlet private weak var btnJSONFilled: Button!
    
    private var onTouchUpInsideDoneButton: Event?
    private var onTouchUpInsideQuotationMarksButton: Event?
    private var onTouchUpInsideJSONEmptyButton: Event?
    private var onTouchUpInsideJSONFilledButton: Event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if iPhone.current.isInfiniteScreen {
            self.viewContainer.layer.masksToBounds = true
            self.viewContainer.layer.cornerRadius = 20
        }
        self.setupTitle(title: "Done", onButton: self.btnDone, withColor: .black)// #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        self.setupTitle(title: "\"...\"", onButton: self.btnQuotationMarks, withColor: .black)// #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        self.setupTitle(title: "{}", onButton: self.btnJSONEmpty, withColor: .black)// #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        self.setupTitle(title: "{...}", onButton: self.btnJSONFilled, withColor: .black)// #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))
        let buttons: [Button] = [self.btnDone, self.btnQuotationMarks, self.btnJSONEmpty, self.btnJSONFilled]
        for btn in buttons {
            btn.onChangeState { (_btn, state) in
                _btn.alpha = state.alpha
            }
        }
        self.btnDone.onTouchUpInside { [weak self] button in
            guard let self = self else { return }
            self.onTouchUpInsideDoneButton?(self)
        }
        self.btnQuotationMarks.onTouchUpInside { [weak self] button in
            guard let self = self else { return }
            self.onTouchUpInsideQuotationMarksButton?(self)
        }
        self.btnJSONEmpty.onTouchUpInside { [weak self] button in
            guard let self = self else { return }
            self.onTouchUpInsideJSONEmptyButton?(self)
        }
        self.btnJSONFilled.onTouchUpInside { [weak self] button in
            guard let self = self else { return }
            self.onTouchUpInsideJSONFilledButton?(self)
        }
        self.lblJSON.text = "JSON: "
        self.lblJSON.textColor = .black
    }
    
    func setButtonDone(enabled: Bool) {
        self.btnDone.isEnabled = enabled
    }
    
    func setJSON(valid: Bool) {
        self.lblStatus.textColor = valid ? DebuggerViewConstants.greenColor : DebuggerViewConstants.redColor
        self.lblStatus.text = valid ? "valid" : "invalid"
    }
    
    func onDonePressed(handler: @escaping Event) {
        self.onTouchUpInsideDoneButton = handler
    }
    
    func onQuotationMarksPressed(handler: @escaping Event) {
        self.onTouchUpInsideQuotationMarksButton = handler
    }
    
    func onJSONEmptyPressed(handler: @escaping Event) {
        self.onTouchUpInsideJSONEmptyButton = handler
    }
    
    func onJSONFilledPressed(handler: @escaping Event) {
        self.onTouchUpInsideJSONFilledButton = handler
    }
    
    private func setupTitle(title: String, onButton button: Button, withColor color: UIColor) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color, for: .highlighted)
    }
    
}
