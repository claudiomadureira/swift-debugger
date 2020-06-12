//
//  DebuggerViewController.swift
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import SwiftArsenal

class DebuggerViewController: UIViewController {
    
    private let customView: DebuggerView = .xib()
    
    enum Event {
        case didDismiss
        case didPressToSeeToggles
        case didPressToDetailAt(Int)
    }
    
    var events = Signal<(DebuggerViewController, Event)>()
    var didAppear: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        self.view = self.customView
        self.customView.delegate = self
        self.customView.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSideMenuAndShadow(hidden: true)
        self.customView.alpha = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !self.didAppear else { return }
        self.didAppear = true
        self.customView.animateSideMenu(toHide: false, completion: nil)
    }
    
    func setSideMenuHidden(progress: CGFloat) {
        self.customView.setSideMeuHidden(progress: progress)
    }
    
    func animateSideMenu(hidden: Bool, animated: Bool, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.setSideMenuHidden(progress: hidden ? 1 : 0)
        }, completion: { _ in
            completion?()
        })
    }
    
    func setSideMenuAndShadow(hidden: Bool) {
        self.customView.setSideMenuAndShadow(hidden: hidden)
    }
    
}

extension DebuggerViewController: DebuggerViewDelegate {
    
    func debugger(_ view: DebuggerView, didPressToDetailAt index: Int) {
        self.events.emit((self, .didPressToDetailAt(index)))
    }
    
    func debugger(_ view: DebuggerView, didDismiss animated: Bool) {
        self.events.emit((self, .didDismiss))
    }
    
    func debugger(_ view: DebuggerView, didPressClearLog button: UIButton) {
        Debug.shared.clearLogs()
        view.clearLog(animated: false, completion: nil)
    }
    
    func debugger(_ view: DebuggerView, didPressToggles button: UIButton) {
        self.events.emit((self, .didPressToSeeToggles))
    }
    
}
