//
//  LogStorage.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 5/27/20.
//

import UIKit

enum LogStorage {
    
    // MARK: Variables
    
    private static let storage: UserDefaults = .standard
    private static var models: [Data] = LogStorage.getAllData()
    private static let storageKey: String = "Debug.storage"
    
    // MARK: Local public
    
    static func save(_ model: DebuggerModel) {
        guard let data = self.parseToData(model: model) else { return }
        self.models.append(data)
        self.storage.set(self.models, forKey: self.storageKey)
    }
    
    static func getAll() -> [DebuggerModel] {
        return self.getAllData().compactMap({ self.parseToModel(data: $0) })
    }
    
    static func removeAll() {
        self.storage.set([], forKey: self.storageKey)
    }
    
    // MARK: Private
    
    private static func getAllData() -> [Data] {
        return self.storage.value(forKey: self.storageKey) as? [Data] ?? []
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
