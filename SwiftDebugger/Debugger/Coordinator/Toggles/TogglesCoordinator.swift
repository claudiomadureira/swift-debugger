//
//  TogglesCoordinator.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class TogglesCoordinator: Coordinator {
    
    let rootViewController: UIViewController
    
    var togglesNavigationController: TogglesNavigationViewController?
    
    enum Event {
        case didPanToDismissToggles(CGFloat)
        case didFinish
    }
    
    let events = Signal<(TogglesCoordinator, Event)>()
    
    required init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewController = UIViewController()
        viewController.title = "Toggles"
        viewController.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        let navController = TogglesNavigationViewController(rootViewController: viewController)
        navController.events.on { [weak self] (vc, event) in
            switch event {
            case .didPanToDismiss(let progress):
                guard let self = self else { return }
                self.events.emit((self, .didPanToDismissToggles(progress)))
            case .didHide:
                self?.finish()
            }
        }
        navController.modalPresentationStyle = .overCurrentContext
        navController.view.alpha = 0
        self.togglesNavigationController = navController
        self.rootViewController.present(navController, animated: false, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.togglesNavigationController?.setTogglesNavigationControllerHidden(progress: 1)
            self?.togglesNavigationController?.view.alpha = 1
            self?.togglesNavigationController?.animate(toHide: false, duration: 0.3, completion: nil)
        })
    }
    
    func finish() {
        self.togglesNavigationController?.dismiss(animated: false, completion: nil)
        self.events.emit((self, .didFinish))
    }
    

}
