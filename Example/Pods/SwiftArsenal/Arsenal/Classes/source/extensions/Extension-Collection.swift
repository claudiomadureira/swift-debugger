//
//  Extension-Collection.swift
//
//  Created by Claudio Madureira on 19/12/19.
//

import Foundation

public extension Collection {
    
    /// Identifies collection has a single element or more. (isEmpty opposite)
    var hasElements: Bool {
        return !self.isEmpty
    }
    
    /// Safely get an element inside an array. This avoids `index out of range`.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
}
