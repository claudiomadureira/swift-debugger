//
//  SettingsCoordinator.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//

import UIKit

class SettingsCoordinator: LeftCoordinator {
    
    override func getFirstViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.title = "Settings"
        viewController.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return viewController
    }
    
}
