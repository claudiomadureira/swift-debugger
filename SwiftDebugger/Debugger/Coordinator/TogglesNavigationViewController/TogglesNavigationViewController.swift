//
//  TogglesNavigationViewController.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/18/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

class TogglesNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.navigationBar.barStyle = UIBarStyle.black
        self.navigationBar.tintColor = .white
        self.navigationBar.isTranslucent = false
    }
    

}
