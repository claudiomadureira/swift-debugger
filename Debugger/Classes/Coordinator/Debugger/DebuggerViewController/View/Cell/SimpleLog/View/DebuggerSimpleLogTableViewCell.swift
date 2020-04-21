//
//  DebuggerSimpleLogTableViewCell.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

class DebuggerSimpleLogTableViewCell: UITableViewCell {

    @IBOutlet private weak var lblTop: UILabel!
    @IBOutlet private weak var lblBottom: UILabel!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private weak var btn: Button!
    
    var viewModel: DebuggerSimpleLogViewModel? {
        didSet {
            self.lblTop.text = self.viewModel?.logTopText()
            self.lblTop.textColor = self.viewModel?.logTopTextColor()
            self.lblBottom.text = self.viewModel?.dateBottomText()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.lineView.backgroundColor = DebuggerViewConstants.lineColor
        self.lblTop.font = DebuggerViewConstants.fontRegular
        self.lblBottom.font = DebuggerViewConstants.fontThin
        self.lblBottom.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.btn.onChangeState { (btn, state) in
            btn.superview?.alpha = state.alpha
        }
    }
    
    func onTouchUpInside(_ handler: @escaping () -> Void) {
        self.btn.onTouchUpInside { (btn) in
            handler()
        }
    }
    
}
