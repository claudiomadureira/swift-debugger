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
    private let viewModel: SettingsViewModel = .init()
    
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.title = "Settings"
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func loadView() {
        self.customView.viewModel = self.viewModel
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(self.onSavePressed))
        self.navigationItem.rightBarButtonItem = button
        self.updateSaveButtonEnabled()
        self.customView.onJSONTextChanged { [weak self] (view) in
            self?.updateSaveButtonEnabled()
        }
    }
    
    private func updateSaveButtonEnabled() {
        let text: String? = self.customView.text
        self.navigationItem.rightBarButtonItem?.isEnabled = !self.viewModel.isSettingsEqualFromFirstOne(settingsText: text) && !self.viewModel.isSettingsInvalid(settingsText: text)
    }
    
    @objc
    private func onSavePressed() {
        self.viewModel.saveJSON(jsonText: self.customView.text)
        self.updateSaveButtonEnabled()
    }

}
