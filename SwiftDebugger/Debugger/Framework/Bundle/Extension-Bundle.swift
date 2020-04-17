//
//  Extension-Bundle.swift
//
//  Created by Claudio Madureira Silva Filho on 4/8/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

extension Bundle {
    
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
