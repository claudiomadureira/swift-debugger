//
//  SettingsViewController.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/25/20.
//

import UIKit
import SwiftArsenal

class SettingsViewController: UIViewController {
    
    private let customView: SettingsView = .xib()
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Settings"
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        self.view = self.customView
    }

}
