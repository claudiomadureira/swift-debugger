//
//  AlwaysSelectedCollectionViewCell.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/7/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class AlwaysSelectedCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var lbl: UILabel!
    @IBOutlet private weak var btn: Button!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.lbl.layer.masksToBounds = true
        self.lbl.layer.cornerRadius = 15
        self.lbl.font = UIFont.systemFont(ofSize: 15)
        self.lbl.layer.borderColor = #colorLiteral(red: 0.1275281176, green: 0.5, blue: 0.2235056768, alpha: 1).cgColor
        self.btn.onChangeState { [weak self] (btn, state) in
            self?.lbl.alpha = state.alpha
        }
    }
    
    func setInfo(isSelected: Bool, completion: (() -> Void)?) {
        self.lbl.backgroundColor = isSelected ? #colorLiteral(red: 0.1990376711, green: 0.7803677917, blue: 0.3488332629, alpha: 1) : .gray
        self.lbl.textColor = isSelected ? .white : .black
        self.lbl.font = UIFont.systemFont(ofSize: 15, weight: isSelected ? .bold : .regular)
        self.lbl.layer.borderWidth = isSelected ? 2 : 0
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            let scale: CGFloat = isSelected ? 1 : 0.8
            self?.lbl.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        }, completion: { _ in
            completion?()
        })
    }
    
    func setInfo(text: String, isSelected: Bool, onTouchUpInside: @escaping () -> Void) {
        self.lbl.text = text
        self.lbl.backgroundColor = isSelected ? #colorLiteral(red: 0.1990376711, green: 0.7803677917, blue: 0.3488332629, alpha: 1) : .gray
        self.lbl.textColor = isSelected ? .white : .black
        self.lbl.font = UIFont.systemFont(ofSize: 15, weight: isSelected ? .bold : .regular)
        self.lbl.layer.borderWidth = isSelected ? 2 : 0
        let scale: CGFloat = isSelected ? 1 : 0.8
        self.lbl.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        self.btn.onTouchUpInside { _ in
            onTouchUpInside()
        }
    }

}
