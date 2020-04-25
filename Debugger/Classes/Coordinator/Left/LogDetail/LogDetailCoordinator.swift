//
//  LogDetailCoordinator.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/20/20.
//

import UIKit

class LogDetailCoordinator: LeftCoordinator {
    
    let index: Int
    
    lazy var firstViewController: UIViewController = {
        let model = Debug.items[self.index]
        return DebugDetailViewController(model: model)
    }()
    
    init(rootViewController: UIViewController, index: Int) {
        self.index = index
        super.init(rootViewController: rootViewController)
    }
    
    required init(rootViewController: UIViewController) {
        self.index = 0
        super.init(rootViewController: rootViewController)
    }
    
    override func getFirstViewController() -> UIViewController {
        return self.firstViewController
    }
    
}
