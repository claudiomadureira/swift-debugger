//
//  ViewController.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/6/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit
import Debugger

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let item0 = ExampleHTTPResquest(
            url: "https://test.api.com/some-image",
            method: "get",
            statusCode: 404,
            headers: [:],
            body: Data(),
            responseBody: Data(),
            startDate: nil,
            duration: 3)
        Debug.shared.debug(item0)
        
        let item1 = ExampleHTTPResquest(
            url: "https://test.api.com/some-image2",
            method: "get",
            statusCode: 200,
            headers: [:],
            body: Data(),
            responseBody: UIImage(named: "testImage")?.pngData() ?? Data(),
            startDate: nil,
            duration: 150)
        Debug.shared.debug(item1)
    }
    
    
    
}
