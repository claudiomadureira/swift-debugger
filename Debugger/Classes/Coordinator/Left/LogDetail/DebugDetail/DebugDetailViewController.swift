//
//  DebugDetailViewController.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/21/20.
//

import UIKit

class DebugDetailViewController: UIViewController {

    private let customView: DebugDetailView = .xib()
    private let viewModel: DebugDetailViewModel
    
    required init(model: DebuggerModel) {
        self.viewModel = DebugDetailViewModel(model: model)
        super.init(nibName: nil, bundle: nil)
        self.title = self.viewModel.title
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customView.viewModel = self.viewModel
    }
    
}
