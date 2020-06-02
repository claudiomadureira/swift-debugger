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
        var all = self.getAll()
        all.append(model)
        self.storage.set(all.map({ self.parseToData(model: $0) }), forKey: "storage")
    }
    
    static func getAll() -> [DebuggerModel] {
        let array: [Data] = self.storage.value(forKey: "storage") as? [Data] ?? []
        return array.compactMap({ self.parseToModel(data: $0) })
    }
    
    static func removeAll() {
        self.storage.set([], forKey: "storage")
    }
    
    private static func parseToData(model: DebuggerModel) -> Data? {
        let encoder = JSONEncoder()
        if let model = model as? DebuggerDecodingErrorModel {
            do {
                return try encoder.encode(model)
            } catch let error {
                
            }
        }
        if let model = model as? LogModel {
            do {
                return try encoder.encode(model)
            } catch let error {
                
            }
        }
        if let model = model as? DebuggerHTTPRequestModel {
            do {
                return try encoder.encode(DebuggerHTTPRequest.from(model: model))
            } catch let error {
                
            }
        }
        
        
        
        return nil
    }
    
    private static func parseToModel(data: Data) -> DebuggerModel? {
        let decoder = JSONDecoder()
        if let model = try? decoder.decode(DebuggerDecodingErrorModel.self, from: data) {
            return model
        }
        if let model = try? decoder.decode(LogModel.self, from: data) {
            return model
        }
        if let model = try? decoder.decode(DebuggerHTTPRequest.self, from: data) {
            return model
        }
        
        return nil
    }
    
}
