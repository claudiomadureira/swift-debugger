//
//  TogglesCoordinator.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class TogglesCoordinator: LeftCoordinator {
    
    override func getFirstViewController() -> UIViewController {
        let viewController = UIViewController()
        viewController.title = "Toggles"
        viewController.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return viewController
    }
    
}
