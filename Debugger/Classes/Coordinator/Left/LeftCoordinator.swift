//
//  LeftCoordinator.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

class LeftCoordinator: Coordinator {
    
    let rootViewController: UIViewController
    
    var togglesNavigationController: LeftNavigationViewController?
    
    enum Event {
        case didPanToDismissToggles(CGFloat)
        case willStart
        case willFinish
        case didStart
        case didFinish
    }
    
    let events = Signal<(LeftCoordinator, Event)>()
    
    required init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let navController = LeftNavigationViewController(rootViewController: self.getFirstViewController())
        navController.events.on { [weak self] (vc, event) in
            switch event {
            case .didPanToDismiss(let progress):
                guard let self = self else { return }
                self.events.emit((self, .didPanToDismissToggles(progress)))
            case .viewWillAppear:
                self?.willStart()
            case .viewWillDisapper:
                self?.willFinish()
            case .viewDidAppear:
                self?.willFinish()
            case .viewDidDisapper:
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
            self?.togglesNavigationController?.animate(toHide: false, duration: 0.3, completion: { [weak self] in
                self?.didStart()
            })
        })
    }
    
    func finish() {
        self.togglesNavigationController?.dismiss(animated: false, completion: nil)
        self.events.emit((self, .didFinish))
    }
    
    func getFirstViewController() -> UIViewController {
        return .init()
    }
    
    private func willStart() {
        self.events.emit((self, .willStart))
    }
    
    private func didStart() {
        self.events.emit((self, .didStart))
    }
    
    private func willFinish() {
        self.events.emit((self, .willStart))
    }
    
    
}
