//
//  DebuggerHTTPRequestTableViewCell.swift
//
//  Created by Claudio Madureira Silva Filho on 4/15/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class DebuggerHTTPRequestTableViewCell: UITableViewCell {

    @IBOutlet private weak var lblURL: UILabel!
    @IBOutlet private weak var lblMethod: UILabel!
    @IBOutlet private weak var lblStatusCode: UILabel!
    @IBOutlet private weak var lblStartedAt: UILabel!
    @IBOutlet private weak var lblDuration: UILabel!
    @IBOutlet private weak var imvBody: UIImageView!
    @IBOutlet private weak var btn: Button!
    
    var viewModel: DebuggerHTTPRequestCellViewModel? {
        didSet {
            self.lblURL.text = self.viewModel?.getTopText()
            self.lblMethod.text = self.viewModel?.getMiddleText()
            self.lblStatusCode.text = self.viewModel?.getStatusCodeText()
            self.lblStatusCode.textColor = self.viewModel?.getStatusCodeColor()
            self.lblDuration.text = self.viewModel?.getBottomRightText()
            self.lblStartedAt.text = self.viewModel?.getStartedAtText()
            let image = self.viewModel?.getImage()
            self.imvBody.image = image
            let hasImage = image != nil
            self.imvBody.layer.borderWidth = hasImage ? 2 : 0
            self.imvBody.backgroundColor = hasImage ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : .clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        let size: CGFloat = 14
        let fontRegular: UIFont = UIFont.systemFont(ofSize: size, weight: .regular)
        let fontBold: UIFont = UIFont.systemFont(ofSize: size, weight: .bold)
        self.lblURL.font = fontRegular
        self.lblMethod.font = fontRegular
        self.lblStatusCode.font = fontBold
        self.lblStartedAt.font = fontRegular
        self.lblDuration.font = fontRegular
        self.imvBody.layer.masksToBounds = true
        self.imvBody.layer.cornerRadius = 6
        self.imvBody.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        self.btn.onChangeState { (btn, state) in
            btn.superview?.alpha = state.alpha
        }
    }
    
}
