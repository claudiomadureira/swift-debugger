//
//  LogStorage.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 5/27/20.
//

import UIKit

enum LogStorage {
    
    private static let storage: UserDefaults = .standard
    
    
    static func save(_ model: DebuggerModel) {
        //        let data = self.parseToData(model: model)
//        self.storage.set(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
    }
    
    static func getAll() -> [DebuggerModel] {
        return []
    }
    
    static func removeAll() {
        
    }
        
    //    private static func parseToData(model: DebuggerModel) -> Data {
    //        DebuggerHTTPRequestModel
    //
    //        return .init()
    //    }
    //
    //    private static func parseToModel(data: Data) -> DebuggerModel {
    //
    //        return .init()
    //    }
    
}
