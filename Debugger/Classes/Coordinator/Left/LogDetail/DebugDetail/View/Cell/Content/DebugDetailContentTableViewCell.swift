//
//  DebugDetailContentTableViewCell.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

class ContentTextView: UITextView {}

class DebugDetailContentTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var textView: ContentTextView!
    @IBOutlet private weak var constTrailingTextView: NSLayoutConstraint!
    @IBOutlet private weak var constHeightTextView: NSLayoutConstraint!
    
    
    var viewModel: DebugDetailContentItemViewModel? {
        didSet {
            self.textView.text = self.viewModel?.getText()
            let shouldBreakLine = self.viewModel?.getShouldBreakLine() ?? false
            self.constTrailingTextView.constant = shouldBreakLine ? 20 : -10000
            var constant = self.getTextSize().height
            let minConstant: CGFloat = 30
            if constant < minConstant {
                constant = minConstant
            }
            self.constHeightTextView.constant = constant
            self.textView.isScrollEnabled = !shouldBreakLine
            self.contentView.layoutIfNeeded()
        }
    }
    
    private let textFont: UIFont = .systemFont(ofSize: 18)

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.textView.backgroundColor = .clear
        self.textView.isEditable = false
    }
    
    func getTextSize() -> CGSize {
        if let viewModel = self.viewModel {
            let infinity: CGFloat = .infinity
            return NSString(string: viewModel.getText())
                       .boundingRect(
                           with: CGSize(width: infinity, height: infinity),
                           options: NSStringDrawingOptions.usesLineFragmentOrigin,
                           attributes: [NSAttributedString.Key.font: self.textFont as Any],
                           context: nil).size
        }
        return .zero
    }
    
}
