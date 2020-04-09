//
//  DebuggerView.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/7/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class DebuggerView: UIView, NibLoadable {
    
    @IBOutlet private weak var sideMenu: UIView!
    @IBOutlet private weak var lblEnvironments: UILabel!
    @IBOutlet private weak var collectionLocalizations: AlwaysSelectedCollectionView!
    @IBOutlet private weak var lblLocalizations: UILabel!
    @IBOutlet private weak var collectionEnvironments: AlwaysSelectedCollectionView!
    @IBOutlet private weak var lblIdentifier: UILabel!
    @IBOutlet private weak var switchIdentifier: UISwitch!
    @IBOutlet private weak var lblLog: UILabel!
    @IBOutlet private weak var btnExpand: Button!
    @IBOutlet private weak var lblVersion: UILabel!
    @IBOutlet private weak var viewHiddablePointer: UIView!
    @IBOutlet private weak var viewHiddableSideMenu: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpHiddablePointer()
        self.setUpSideMenuBackground()
        self.lblEnvironments.text = "Environment"
        self.collectionEnvironments.delegateAwlaysSelected = self
        self.collectionEnvironments.items = Debugger.shared.environments
        self.lblLocalizations.text = "Localization"
        self.collectionLocalizations.delegateAwlaysSelected = self
        self.collectionLocalizations.items = Debugger.shared.localizations
        self.lblIdentifier.text = "Identifier"
        self.switchIdentifier.setOn(!Debugger.shared.labelTextIdentifierIsHidden, animated: false)
        self.lblLog.text = "Log"
        self.setUpButtonExpand()
        self.lblVersion.text = "Main bundle at " + Bundle.main.readableVersion
        self.addDismissSideMenuTapGesture()
        self.addDismissSideMenuPanGesture()
        self.setSideMenu(hidden: true)
        self.alpha = 0
    }
    
    func appearInAnimated() {
        self.animate(toHide: false, completion: {
            self.animateSideMenu(toHide: false, completion: nil)
        })
    }
    
    private func setUpHiddablePointer() {
        self.viewHiddablePointer.layer.masksToBounds = true
        self.viewHiddablePointer.layer.cornerRadius = 2.5
        self.viewHiddablePointer.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
    
    private func addDismissSideMenuPanGesture() {
        let gesture = InitialTouchPanGestureRecognizer(target: self, action: #selector(self.panGesturePanned))
        self.sideMenu.addGestureRecognizer(gesture)
        let _gesture = InitialTouchPanGestureRecognizer(target: self, action: #selector(self.panGesturePanned))
        self.viewHiddableSideMenu.addGestureRecognizer(_gesture)
    }
    
    private func addDismissSideMenuTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapDismissSideMenuAction))
        self.addGestureRecognizer(gesture)
    }
    
    private func setUpButtonExpand() {
        self.btnExpand.setTitle(nil, for: .normal)
        self.btnExpand.setTitle(nil, for: .highlighted)
        let image = UIImage(named: "expand")?
            .resize(to: CGSize(width: 25, height: 25))
            .tintPicto(.white)
        self.btnExpand.setImage(image, for: .normal)
        self.btnExpand.setImage(image, for: .highlighted)
        self.btnExpand.onChangeState { (btn, state) in
            let scale: CGFloat = state.alpha == 0.4 ? 0.8 : state.alpha
            btn.transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        }
    }
    
    private func setUpSideMenuBackground() {
        self.sideMenu.backgroundColor = .clear
        
        // Adding corner and border below
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.0700000003, green: 0.0700000003, blue: 0.0700000003, alpha: 1)
        view.layer.borderWidth = 1
        view.layer.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        self.sideMenu.insertSubview(view, at: 0)
        self.sideMenu.addConstraints([
            view.topAnchor.constraint(equalTo: self.sideMenu.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.sideMenu.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.sideMenu.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.sideMenu.trailingAnchor, constant: 30)])
    }
    
    private func setSideMenu(hidden: Bool) {
        self.setSideMeuHidden(progress: hidden ? 1 : 0)
    }
    
    private func setSideMeuHidden(progress: CGFloat) {
        guard progress >= 0 && progress <= 1 else { return }
        let x: CGFloat = (UIScreen.main.bounds.size.width/2 + 30)*progress
        self.sideMenu.transform = CGAffineTransform.identity.translatedBy(x: x, y: 0)
        self.viewHiddablePointer.transform = self.sideMenu.transform
    }
    
    private func animateSideMenu(toHide: Bool, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.setSideMenu(hidden: toHide)
            }, completion: { _ in
                completion?()
        })
    }
    
    private func animate(toHide: Bool, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.alpha = toHide ? 0 : 1
            }, completion: { _ in
            completion?()
        })
    }
    
    @objc
    private func tapDismissSideMenuAction() {
        self.animateSideMenu(toHide: true) {
            self.animate(toHide: true, completion: { [weak self] in
                self?.removeFromSuperview()
            })
        }
    }
    
    @objc
    private func panGesturePanned(_ gesture: UIPanGestureRecognizer) {
        let point = gesture.translation(in: gesture.view?.superview)
        
        switch gesture.state {
        case .cancelled, .failed:
            self.animateSideMenu(toHide: false, completion: nil)
        case .began:
            break
        case .ended:
            let speed = gesture.velocity(in: gesture.view).x
            if speed == 100 {
                let translatedX = self.sideMenu.transform.tx
                let toHide = translatedX > UIScreen.main.bounds.width/4
                self.animateSideMenu(toHide: toHide) { [weak self] in
                    if toHide {
                        self?.animate(toHide: toHide, completion: { [weak self] in
                            self?.removeFromSuperview()
                        })
                    }
                }
            } else {
                let toHide = speed > 100
                self.animateSideMenu(toHide: toHide) { [weak self] in
                    if toHide {
                        self?.animate(toHide: toHide, completion: { [weak self] in
                            self?.removeFromSuperview()
                        })
                    }
                }
            }
            
        default:
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
                let x = point.x < 0 ? 0 : point.x
                self.sideMenu.transform = CGAffineTransform.identity.translatedBy(x: x, y: 0)
                self.viewHiddablePointer.transform = self.sideMenu.transform
            }, completion: nil)
            
        }
    }
    
}


extension DebuggerView: AlwaysSelectedCollectionViewDelegate {
    
    func collection(collectionView: AlwaysSelectedCollectionView, didSelectItemAt index: Int) {
        switch collectionView {
        case self.collectionEnvironments:
            Debugger.shared.emit(event: .didChangeEnvironment(collectionView.items[index]))
        case self.collectionLocalizations:
            Debugger.shared.emit(event: .didChangeLocalization(collectionView.items[index]))
        default:
            break
        }
    }
    
}
