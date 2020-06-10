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
    
    private var onTouchUpInsideDoneButton: Event?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if iPhone.current.isInfiniteScreen {
            self.viewContainer.layer.masksToBounds = true
            self.viewContainer.layer.cornerRadius = 20
        }
        self.btnDone.setTitle("Done", for: .normal)
        let titleColor: UIColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        self.btnDone.setTitleColor(titleColor, for: .normal)
        self.btnDone.setTitleColor(titleColor, for: .highlighted)
        self.btnDone.onChangeState { (btn, state) in
            btn.alpha = state.alpha
        }
        self.btnDone.onTouchUpInside { [weak self] button in
            guard let self = self else { return }
            self.onTouchUpInsideDoneButton?(self)
        }
        self.lblJSON.text = "JSON: "
        self.lblJSON.textColor = .white
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
    
}
