//
//  ExampleBuilder.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

enum ExampleBuilder {

    static func example<Model: Decodable>(for model: Model.Type, inputData: Data?) -> [String: Any] {
        var json: [String: Any] = [:]
        if let data = inputData,
            let _json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            json = _json
        }
        while ((try? JSONDecoder().decode(model, from: json.data)) == nil) {
            do {
                _ = try JSONDecoder().decode(model, from: json.data)
            } catch let error {
                switch error {
                 case DecodingError.keyNotFound(let key, let context):
                    var anything: String?
                    json.updateValue(anything as Any, forKey: key.stringValue)
                           
                case DecodingError.valueNotFound(let value, let context):
                    let parameterType =  context.debugDescription.parameterType
                    let key = context.codingPath.first?.stringValue ?? ""
                    switch parameterType.lowercased() {
                    case "object":
                        json.updateValue([:], forKey: key)
                    case "array":
                        if let exampleType = StringExample.allCases.first(where: { type in
                            let result = type.keyExamples.first(where: { exampleKey in
                                return key.contains(exampleKey)
                            })
                            return result != nil
                        }) {
                            json.updateValue([exampleType.examples.randomElement()!], forKey: key)
                        } else {
                            json.updateValue([], forKey: key)
                        }
                    case "string":
                        if let exampleType = StringExample.allCases.first(where: { $0.keyExamples.contains(key) }) {
                            json.updateValue(exampleType.examples.randomElement()!, forKey: key)
                        } else {
                            json.updateValue("", forKey: key)
                        }
                    case "double", "number":
                        json.updateValue(10.0, forKey: key)
                    case "int":
                        json.updateValue(1, forKey: key)
                    default:
                        break
                    }
                default:
                    break
                }
            }
        }
        return json
    }
    
}


extension Collection {
    
    var data: Data {
        return (try? JSONSerialization.data(withJSONObject: self)) ?? Data()
    }
    
}
