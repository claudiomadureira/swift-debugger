//
//  DebugDetailTitleTableViewCell.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

class DebugDetailTitleTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var lbl: UILabel!
    
    var viewModel: DebugDetailTitleItemViewModel? {
        didSet {
            self.lbl.text = self.viewModel?.getText()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.lbl.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
}
