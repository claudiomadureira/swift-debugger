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
        let viewController = DebugDetailViewController(model: model)
        if model is LogModel {
            viewController.title = "Log"
        }
        if let model = model as? DebuggerErrorModel {
            viewController.title = model.modelName
        }
        if let model = model as? DebuggerHTTPRequestModel {
            let viewModel = DebuggerHTTPRequestCellViewModel(model: model)
            viewController.title = viewModel.getTopText()
        }
        viewController.view.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
       
        return viewController
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
