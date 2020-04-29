//
//  ScreenMargin.swift
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//

import UIKit

/// This contain the respective margin used by status bar and the bottom space on infinite screen iPhones X, XS, XR, XS Max, 11, 11 Pro and 11 Pro Max.
public enum ScreenMargin {
    
    public static var iPhone4: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    
    /// Also iPhones 5S and SE.
    public static var iPhone5: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    
    /// Also iPhones 6S, 7, 8 and SE Second Generation.
    public static var iPhone6: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    
    /// Also iPhones 6S Plus, 7 Plus and 8 Plus.
    public static var iPhone6Plus: UIEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    
    /// Also iPhones 11.
    public static var iPhoneXR: UIEdgeInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 34)
    
    /// Also iPhones XS and 11 Pro.
    public static var iPhoneX: UIEdgeInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 34)
    
    /// Also iPhones 11 Pro Max.
    public static var iPhoneXSMax: UIEdgeInsets = UIEdgeInsets(top: 44, left: 0, bottom: 0, right: 34)
    
    /// The current iPhone running the app.
    public static var current: UIEdgeInsets {
        switch iPhoneSreen.current {
        case .iPhone4:
            return self.iPhone5
        case .iPhone5:
            return self.iPhone5
        case .iPhone6:
            return self.iPhone6
        case .iPhone6Plus:
            return self.iPhone6Plus
        case .iPhoneXR:
            return self.iPhoneXR
        case .iPhoneX:
            return self.iPhoneX
        case .iPhoneXSMax:
            return self.iPhoneXSMax
        }
    }
    
}
