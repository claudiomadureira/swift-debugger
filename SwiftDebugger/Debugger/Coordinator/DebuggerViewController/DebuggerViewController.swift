//
//  DebuggerViewController.swift
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

class DebuggerViewController: UIViewController {
    
    private let customView: DebuggerView = .xib()
    
    enum Event {
        case didDismiss
    }
    
    var events = Signal<(DebuggerViewController, Event)>()
    var didAppear: Bool = false
    
    override func loadView() {
        self.view = self.customView
        self.customView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customView.setSideMenu(hidden: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !self.didAppear else { return }
        self.didAppear = true
        self.customView.animateSideMenu(toHide: false, completion: nil)
    }
    
}

extension DebuggerViewController: DebuggerViewDelegate {
    
    func debugger(_ view: DebuggerView, didDismiss animated: Bool) {
        self.events.emit((self, .didDismiss))
    }
    
    func debugger(_ view: DebuggerView, didPressClearLog button: UIButton) {
        
    }
    
    func debugger(_ view: DebuggerView, didPressToggles button: UIButton) {
        
    }
    
}
