//
//  Extension-Int.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

extension Int {
    
    var readableDuration: String {
        let duration = self
        if duration > 120 {
            let minutes = duration/60
            let rest = duration - 60*Int(Double(duration)/60.0)
            var text = String(minutes) + "m"
            if rest > 0 {
                text.append(" " + String(rest) + "s")
            }
            return text
        }
        return String(duration) + "s"
    }
    
}
