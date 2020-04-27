//
//  Extension-Array.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

extension Array {

    func random() -> Element {
        return self[Int.random(in: 0 ..< self.count)]
    }
    
}
