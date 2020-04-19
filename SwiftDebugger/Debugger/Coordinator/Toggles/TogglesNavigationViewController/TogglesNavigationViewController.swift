//
//  TogglesNavigationViewController.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class TogglesNavigationViewController: UINavigationController {
    
    enum Event {
        case didPanToDismiss(CGFloat)
        case didHide
    }
    
    let events = Signal<(TogglesNavigationViewController, Event)>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.0700000003, green: 0.0700000003, blue: 0.0700000003, alpha: 1)
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = false
        self.navigationBar.barTintColor = self.view.backgroundColor
        let gesture = InitialTouchPanGestureRecognizer(target: self, action: #selector(self.panGesturePanned))
        self.view.addGestureRecognizer(gesture)
        self.view.layer.masksToBounds = true
        self.view.layer.cornerRadius = 34
    }
    
    
    func setTogglesNavigationControllerHidden(progress: CGFloat) {
        let smallScale: CGFloat = 0.2
        let largeScale: CGFloat = 1.0
        var scale = largeScale - progress * (1 - smallScale)
        if scale > largeScale {
            scale = largeScale
        } else if scale < smallScale {
            scale = smallScale
        }
        self.view.transform = CGAffineTransform.identity
            .translatedBy(x: -UIScreen.main.bounds.width*progress, y: 0)
            .scaledBy(x: scale, y: scale)
    }
    
    func animate(toHide: Bool, emitProgress: Bool = false, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            let progress: CGFloat = toHide ? 1 : 0
            self?.setTogglesNavigationControllerHidden(progress: progress)
            if emitProgress {
                guard let self = self else { return }
                self.events.emit((self, .didPanToDismiss(progress)))
            }
        }, completion: { _ in
            if toHide {
                self.events.emit((self, .didHide))
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
            break
        case .ended:
            let speed = gesture.velocity(in: gesture.view).x
            if speed == -100 {
                let translatedX = self.view.transform.tx
                let toHide = translatedX > UIScreen.main.bounds.width/4
                self.animate(toHide: toHide, emitProgress: true, completion: nil)
            } else {
                let toHide = speed < -100
                self.animate(toHide: toHide, emitProgress: true, completion: nil)
            }
            
        default:
            var progress: CGFloat = point.x/(UIScreen.main.bounds.width/2)
            if progress > 0 {
                progress = 0
            }
            progress = -progress
            self.setTogglesNavigationControllerHidden(progress: progress)
            self.events.emit((self, .didPanToDismiss(progress)))
        }
    }
    
    
}
