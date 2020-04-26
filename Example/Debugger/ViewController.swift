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
        let json: [String: Any] = [
            "email": "claudiomsilvaf@gmail.com",
            "password": "12345",
            "time": [
                "date": "\(Date())",
                "zone": "-3"
            ]
        ]
        let dataJSON = try! JSONSerialization.data(withJSONObject: json)
        let item0 = ExampleHTTPResquest(
            url: "https://test.api.com/auth",
            method: "connect",
            statusCode: 404,
            headers: [
                "X-Authorization": "Bearer SAD812n0dl3km1239n08dsfn1230uhs8djISDJ08ysFh91g2SUD",
                "Content-Type": "json"
            ],
            body: dataJSON,
            responseBody: nil,
            startDate: Date(),
            duration: 3)
        Debug.debug(item0)
        
//        let item1 = ExampleHTTPResquest(
//            url: "https://test.api.com/some-image2",
//            method: "get",
//            statusCode: 200,
//            headers: [:],
//            body: Data(),
//            responseBody: UIImage(named: "testImage")?.pngData() ?? Data(),
//            startDate: nil,
//            duration: 150)
//        Debug.debug(item1)
        
        Debug.warn("Warning message!")
        Debug.error("Error message!")
        Debug.print("Print message!")
        Debug.success("Success message!")
        
        let data = """
        {
            "userName"
        }
        """.data(using: .utf8)!
        let model = ExampleAuthModel.self
        do {
            let model = try JSONDecoder().decode(model, from: data)
            print(model)
        } catch let error {
            Debug.errorDecoding(error, data: data, modelToConvert: model)
        }
    }
    
    
    
}



struct ExampleAuthModel: Codable {
    var userName: Double
}
