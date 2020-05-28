//
//  StringExample.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 4/26/20.
//

import UIKit

enum StringExample: CaseIterable {
    case date
    case firstName
    case lastName
    case fullName
    case email
    case random
    
    var examples: [String] {
        let fullNames: [String] = [
            "Claudio Madureira",
            "John Henry Smith",
            "Marcus Thibault",
            "Steve Jobs"
        ]
        switch self {
        case .date:
            return (0..<4).map({ number in
                let date = Date().addingTimeInterval(TimeInterval(Int.random(in: 0 ..< 999999999) * (Bool.random() ? 1 : -1)))
                return "\(date)"
            })
        case .firstName:
            return fullNames.compactMap({ $0.components(separatedBy: " ").first })
        case .lastName:
            return fullNames.compactMap({ $0.components(separatedBy: " ").last })
        case .fullName:
            return fullNames
        case .email:
            let hosts: [String] = ["gmail", "outlook", "yahoo"]
            let allNames = fullNames + fullNames.compactMap({ $0.components(separatedBy: " ").first })
            return allNames.map({ fullName in
                var email: String = ""
                let names = fullName.components(separatedBy: " ")
                for name in names {
                    email.append(name.lowercased())
                    if names.count > 2, names.last != name, Bool.random() {
                        email.append(Bool.random() ? "." : "_")
                    }
                }
                let host = hosts.randomElement() ?? ""
                email.append("@" + host + ".com")
                return email
            })
        case .random:
            return (0..<4).map({ _ in return UUID().uuidString })
        }
    }
    
    var keyExamples: [String] {
        switch self {
        case .date:
            return [
                "date",
                "moment",
                "createdAt",
                "created_at",
                "updatedAt",
                "updated_at",
                "deletedAt",
                "deleted_at"
            ]
        case .firstName:
            return ["firstName"]
        case .lastName:
            return ["lastName"]
        case .fullName:
            return ["fullName", "name"]
        case .email:
            return ["email", "mail", "e-mail", "userName", "user_name", "username"]
        case .random:
            return [
                "_id",
                "id",
                "objectId",
                "object_id",
                "uid",
                "identifier",
                "key",
                "password",
                "passkey"
            ]
        }
    }
    
}
