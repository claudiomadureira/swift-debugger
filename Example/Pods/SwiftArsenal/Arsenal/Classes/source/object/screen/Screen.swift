//
//  Screen.swift
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

public enum Screen {
    
    public static var iPhone4: CGRect = CGRect(origin: .zero, size: CGSize(width: 320, height: 480))
    
    /// Also iPhones 5S and SE.
    public static var iPhone5: CGRect = CGRect(origin: .zero, size: CGSize(width: 320, height: 568))
    
    /// Also iPhones 6S, 7, 8 and SE Second Generation.
    public static var iPhone6: CGRect = CGRect(origin: .zero, size: CGSize(width: 375, height: 667))
    
    /// Also iPhones 6S Plus, 7 Plus and 8 Plus.
    public static var iPhone6Plus: CGRect = CGRect(origin: .zero, size: CGSize(width: 414, height: 895))
    
    /// Also iPhones 11.
    public static var iPhoneXR: CGRect = CGRect(origin: .zero, size: CGSize(width: 414, height: 895))
    
    /// Also iPhones XS and 11 Pro.
    public static var iPhoneX: CGRect = CGRect(origin: .zero, size: CGSize(width: 375, height: 812))
    
    /// Also iPhones 11 Pro Max.
    public static var iPhoneXSMax: CGRect = CGRect(origin: .zero, size: CGSize(width: 414, height: 895))
    
    /// The current iPhone Screen running the app.
    public static var current: CGRect {
        return UIScreen.main.bounds
    }
    
}
