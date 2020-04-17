//
//  AlwaysSelectedCollectionView.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/7/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

protocol AlwaysSelectedCollectionViewDelegate: class {
    func collection( collectionView: AlwaysSelectedCollectionView, didSelectItemAt index: Int)
}

class AlwaysSelectedCollectionView: UICollectionView {
    
    let cell = AlwaysSelectedCollectionViewCell.self
    
    weak var delegateAwlaysSelected: AlwaysSelectedCollectionViewDelegate?
    
    var cellIdentifier: String {
        return String(describing: self.cell)
    }
    
    var items: [String] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    var selectedIndex: Int = 0 {
        willSet (newValue) {
            let oldCellSeleceted = self.cellForItem(at: [0, self.selectedIndex]) as? AlwaysSelectedCollectionViewCell
            oldCellSeleceted?.setInfo(isSelected: false, completion: { [weak self] in
                let cellSelected = self?.cellForItem(at: [0, newValue]) as? AlwaysSelectedCollectionViewCell
                cellSelected?.setInfo(isSelected: true) { [weak self] in
                    guard let self = self else { return }
                    self.reloadData()
                    self.delegateAwlaysSelected?.collection(collectionView: self, didSelectItemAt: self.selectedIndex)
                }
            })
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.delegate = self
        self.dataSource = self
        let nib = UINib(nibName: self.cellIdentifier, bundle: Bundle(for: self.cell))
        self.register(nib, forCellWithReuseIdentifier: self.cellIdentifier)
    }

    private func getSizeOfText(_ text: String) -> CGSize {
        let infinity: CGFloat = .infinity
        return NSString(string: text)
            .boundingRect(
                with: CGSize(width: infinity, height: 30),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15) as Any],
                context: nil).size
    }
    
}

extension AlwaysSelectedCollectionView: UICollectionViewDelegate {
    
}

extension AlwaysSelectedCollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as! AlwaysSelectedCollectionViewCell
        let item = self.items[indexPath.row]
        cell.setInfo(
            text: item,
            isSelected: indexPath.row == self.selectedIndex) { [weak self] in
                self?.selectedIndex = indexPath.row
        }
        return cell
    }
    
    
}

extension AlwaysSelectedCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.items[indexPath.row]
        let size = self.getSizeOfText(item)
        return .init(width: size.width + 20, height: 50)
    }
    
}
