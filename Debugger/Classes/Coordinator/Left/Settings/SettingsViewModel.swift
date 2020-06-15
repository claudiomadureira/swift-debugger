//
//  SettingsViewModel.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 6/12/20.
//

import UIKit

class SettingsViewModel: NSObject {
    
    var settings: JSON?
    
    override init() {
        super.init()
        self.settings = Debug.shared.localSettings
    }
    
    func saveJSON(jsonText: String?) {
        let settings = self.getSettingsFrom(text: jsonText)
        self.settings = settings
        Debug.shared.localSettings = settings
    }
    
    func getSettingsFrom(text: String?) -> JSON? {
        if let text = text, let data = text.data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: data) as? JSON
        }
        return nil
    }
    
    func getSettingsText() -> String? {
        return Debug.stringfy(self.settings)
    }
    
    func isSettingsInvalid(settingsText: String?) -> Bool {
        if let text = settingsText, let data = text.data(using: .utf8) {
            do {
                let settings = try JSONSerialization.jsonObject(with: data) as? JSON
            } catch let error {
                return true
            }
        }
        return false
    }
    
    func isSettingsEqualFromFirstOne(settingsText: String?) -> Bool {
        let settings = self.getSettingsFrom(text: settingsText)
        if let settings = settings, let initialSettings = self.settings {
            return NSDictionary(dictionary: settings).isEqual(to: initialSettings)
        }
        return settings == nil && self.settings == nil
    }

}
