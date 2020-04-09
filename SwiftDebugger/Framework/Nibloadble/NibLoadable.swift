//
//  NibLoadable.swift
//  SwiftArsenal
//
//  Created by Claudio Madureira Silva Filho on 2/7/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

public protocol NibLoadable {
    static var nibName: String { get }
}

public extension NibLoadable where Self: UIView {
    
    static var nibName: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        let bundle = Bundle(for: Self.self)
        return UINib(nibName: Self.nibName, bundle: bundle)
    }
    
    static func xib() -> Self {
        return self.nib.instantiate(withOwner: nil, options: nil).first as! Self
    }

}
