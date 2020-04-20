//
//  Extension-Bundle.swift
//
//  Created by Claudio Madureira Silva Filho on 4/8/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class LocalBundle { }

extension Bundle {
    
    static let local: Bundle = {
        let podBundle = Bundle(for: LocalBundle.self)
        guard let resourceBundleURL = podBundle.url(forResource: "Debugger", withExtension: "bundle") else {
            return podBundle
        }
        guard let resourceBundle = Bundle(url: resourceBundleURL) else {
            return podBundle
        }
        return resourceBundle
    }()
    
    var releaseVersionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    
    var buildVersionNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
    
    var readableVersion: String {
        return "v" + self.releaseVersionNumber + " (" + self.buildVersionNumber + ")"
    }
    
}
