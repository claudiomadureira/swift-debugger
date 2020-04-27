//
//  Extension-String.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

extension String {

    var parameterType: String {
        let description = self
        var parameterType = description.components(separatedBy: " ")[1]
        if description.contains("Cannot get keyed decoding container") {
            parameterType = "Object"
        }
        if description.contains("Cannot get unkeyed decoding container") {
            parameterType = "Array"
        }
        return parameterType
    }
    
}
