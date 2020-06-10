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
                "X-Authorization": "Bearer " + UUID().uuidString,
                "Content-Type": "application/json"
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
            "objectId": "A21K3Lqp3JH",
            "firstName": "Claudio",
            "lastName": "Madureira",
            "email": "claudiomsilvaf@gmail.com",
            "emails": [""]
        }
        """.data(using: .utf8)!
        let model = ExampleAuthModel.self
        do {
            let model = try JSONDecoder().decode(model, from: data)
            print(model)
        } catch let error {
            Debug.errorDecoding(error, data: data, modelToConvert: model)
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//            self.viewDidLoad()
//        })
    }
    
    
    
}

struct Object: Codable {
    var something: String?
}


struct ExampleAuthModel: Codable {
    var objectId: String
    var firstName: String
    var lastName: String
    var email: String
    var createdAt: String

    var emails: [String]
    var object: Object
}
