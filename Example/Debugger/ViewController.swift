//
//  ViewController.swift
//  Debugger-Example
//
//  Created by Claudio Madureira Silva Filho on 4/6/20.
//  Copyright © 2020. All rights reserved.
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
        Debug.debug(item0)
        
        let item1 = ExampleHTTPResquest(
            url: "https://test.api.com/some-image2",
            method: "get",
            statusCode: 200,
            headers: [:],
            body: Data(),
            responseBody: UIImage(named: "testImage")?.pngData() ?? Data(),
            startDate: nil,
            duration: 150)
        Debug.debug(item1)
        
        Debug.warn("Warning!")
        Debug.error("Error!")
        Debug.print("Print!")
        
        let data = """
        {
            "test": null
        }
        """.data(using: .utf8)!
        do {
            let model = try JSONDecoder().decode(MyCustomModel.self, from: data)
            print(model)
        } catch let error {
            Debug.errorDecoding(error, data: data, modelToConvert: MyCustomModel.self)
        }
    }
    
    
    
}



struct MyCustomModel: Codable {
    var test: String
    
}
