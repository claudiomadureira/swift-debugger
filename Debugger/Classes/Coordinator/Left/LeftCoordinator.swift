//
//  LeftCoordinator.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit
import SwiftArsenal

class LeftCoordinator: Coordinator {
    
    let rootViewController: UIViewController
    
    var navigationController: LeftNavigationViewController?
    
    enum Event {
        case didPanToDismissToggles(CGFloat)
        case dismiss
        case didFinish
    }
    
    let events = Signal<(LeftCoordinator, Event)>()
    
    required init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    func start() {
        let viewController = self.getFirstViewController()
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
                   image: UIImage(named: "back-debug", in: Bundle.local, compatibleWith: nil),
                   style: .plain,
                   target: self,
                   action: #selector(self._dismiss))
        let navController = LeftNavigationViewController(rootViewController: viewController)
        navController.events.on { [weak self] (vc, event) in
            switch event {
            case .didPanToDismiss(let progress):
                guard let self = self else { return }
                self.events.emit((self, .didPanToDismissToggles(progress)))
            case .viewDidDisapper:
                self?.finish()
            default:
                break
            }
        }
        navController.modalPresentationStyle = .overCurrentContext
        navController.view.alpha = 0
        self.navigationController = navController
        self.rootViewController.present(navController, animated: false, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
            self?.navigationController?.setTogglesNavigationControllerHidden(progress: 1)
            self?.navigationController?.view.alpha = 1
            self?.navigationController?.animate(toHide: false, duration: 0.3, completion: nil)
        })
    }
    
    @objc
    private func _dismiss() {
        self.events.emit((self, .dismiss))
        self.dismiss(completion: nil)
    }
    
    func dismiss(completion: (() -> Void)?) {
        self.navigationController?.view.endEditing(false)
        self.navigationController?.animate(toHide: true, duration: 0.3, completion: { [weak self] in
            if let completion = completion {
                completion()
            } else {
                self?.finish()
            }
        })
    }
    
    func finish() {
        self.navigationController?.dismiss(animated: false, completion: nil)
        self.events.emit((self, .didFinish))
    }
    
    func getFirstViewController() -> UIViewController {
        return .init()
    }
    
    
}
