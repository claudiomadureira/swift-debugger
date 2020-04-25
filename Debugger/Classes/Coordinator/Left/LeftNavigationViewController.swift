//
//  LeftNavigationViewController.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class LeftNavigationViewController: UINavigationController {
    
    enum Event {
        case didPanToDismiss(CGFloat)
        case viewWillAppear
        case viewWillDisapper
        case viewDidAppear
        case viewDidDisapper
    }
    
    let events = Signal<(LeftNavigationViewController, Event)>()
    var oldStatusBarStyle: UIStatusBarStyle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.0700000003, green: 0.0700000003, blue: 0.0700000003, alpha: 1)
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = self.view.backgroundColor
        let gesture = InitialTouchPanGestureRecognizer(target: self, action: #selector(self.panGesturePanned))
        self.view.addGestureRecognizer(gesture)
        if iPhone.current.isInfiniteScreen {
            self.view.layer.masksToBounds = true
            self.view.layer.cornerRadius = 34
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.oldStatusBarStyle == nil {
            self.oldStatusBarStyle = UIApplication.shared.statusBarStyle
        }
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let style = self.oldStatusBarStyle {
            UIApplication.shared.statusBarStyle = style
        }
    }
    
    func setTogglesNavigationControllerHidden(progress: CGFloat) {
//        let smallScale: CGFloat = 0.2
//        let largeScale: CGFloat = 1.0
//        var scale = largeScale - progress * (1 - smallScale)
//        if scale > largeScale {
//            scale = largeScale
//        } else if scale < smallScale {
//            scale = smallScale
//        }
        self.view.transform = CGAffineTransform.identity
            .translatedBy(x: -UIScreen.main.bounds.width*progress, y: 0)
//            .scaledBy(x: scale, y: scale)
    }
    
    func animate(toHide: Bool, duration: TimeInterval? = nil, emitProgress: Bool = false, completion: (() -> Void)?) {
        if toHide {
            self.events.emit((self, .viewWillDisapper))
            self.viewWillDisappear(true)
        } else {
            self.viewWillAppear(true)
            self.events.emit((self, .viewWillAppear))
        }
        UIView.animate(withDuration: duration ?? 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            let progress: CGFloat = toHide ? 1 : 0
            self?.setTogglesNavigationControllerHidden(progress: progress)
            if emitProgress {
                guard let self = self else { return }
                self.events.emit((self, .didPanToDismiss(progress)))
            }
        }, completion: { _ in
            if toHide {
                self.viewDidDisappear(true)
                self.events.emit((self, .viewDidDisapper))
            } else {
                self.viewDidAppear(true)
                self.events.emit((self, .viewDidAppear))
            }
        })
    }
    
    @objc
    private func panGesturePanned(_ gesture: InitialTouchPanGestureRecognizer) {
        let point = gesture.translation(in: gesture.view?.superview)
        
        switch gesture.state {
        case .cancelled, .failed:
            self.animate(toHide: false, emitProgress: true, completion: nil)
        case .began:
            self.view.endEditing(false)
        case .ended:
            let speed = gesture.velocity(in: gesture.view).x
            if speed == -100 {
                let translatedX = self.view.transform.tx
                let toHide = translatedX < UIScreen.main.bounds.width/4
                self.animate(toHide: toHide, emitProgress: true, completion: nil)
            } else {
                let toHide = speed < -100
                self.animate(toHide: toHide, emitProgress: true, completion: nil)
            }
            
        default:
            var progress: CGFloat = point.x/(UIScreen.main.bounds.width/3)
            if progress > 0 {
                progress = 0
            }
            progress = -progress
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.setTogglesNavigationControllerHidden(progress: progress)
            }, completion: nil)
            self.events.emit((self, .didPanToDismiss(progress)))
        }
    }
    
    
}
