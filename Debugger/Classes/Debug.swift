//
//  Debug.swift
//
//  Created by Claudio Madureira Silva Filho on 4/8/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit
import SwiftArsenal

public class Debug {
    
    public static var shared: Debug = .init(isLocalStorageEnabled: true)
    
    public var environments: [String] = [] {
        didSet {
            self.indexSelectedEnvironment = 0
        }
    }
    
    public var indexSelectedEnvironment: Int = 0
    
    public var selectedEnvironment: String {
        return self.environments[self.indexSelectedEnvironment]
    }
    
    public var localizations: [String] = [] {
        didSet {
            self.indexSelectedLocalization = 0
        }
    }
    
    public var indexSelectedLocalization: Int = 0
    
    public var selectedLocalization: String {
        return self.localizations[self.indexSelectedLocalization]
    }
    
    public var isLocalStorageEnabled: Bool = true
    public var isVisibleIdentifier: Bool?
    public let events: Signal<Event> = .init()
    
    public var localSettings: [String: Any]? {
        didSet {
            if self.isLocalStorageEnabled {
                Debug.runIfNeeded {
                    Storage.saveSettings(self.localSettings)
                }
            }   
        }
    }
    
    private(set) var items: [DebuggerModel] = []
    
    var mappedItems: [DebuggerItemViewModel] {
        return self.items.compactMap { Debug.factoryViewModel(model: $0) }
    }
    
    var listenerManager = ListenerManager<DebuggerItemViewModel>()
    
    public enum Event {
        case didChangeEnvironment(String)
        case didChangeLocalization(String)
        case didChangeIdentifierVisibility(Bool)
        case didChangeLocalSettings([String: Any]?)
    }
    
    public required init(isLocalStorageEnabled: Bool) {
        self.isLocalStorageEnabled = isLocalStorageEnabled
        self.localSettings = isLocalStorageEnabled ? Storage.getSettings() : nil
        self.items = isLocalStorageEnabled ? Storage.getAll() : []
    }
    
    public func errorDecoding<Model: Decodable>(_ error: Error, data: Data, modelToConvert: Model.Type) {
        guard let _error = error as? DecodingError else { return }
        let exampleJSONString: String = Debug.stringfy(ExampleBuilder.example(for: modelToConvert, inputData: data))
        let modelName: String = "\(modelToConvert)"
        let description: String = ErrorMessageExtractor.description(from: error, modelName: modelName)
        let detailedDescription: String = ErrorMessageExtractor.detailedDescription(from: error)
        let prettyJSONText: String = Debug.stringfy(data)
        let model = DebuggerDecodingErrorModel(
            type: .decodingError,
            exampleJSONString: exampleJSONString,
            modelName: modelName,
            description: description,
            detailedDescription: detailedDescription,
            readableData: prettyJSONText)
        self.debug(model)
        self.log(model.type.printTag + model.description + "\nInput data:\n" + prettyJSONText)
    }
    
    public func success(_ text: String) {
        let model = LogModel(
            description: text,
            type: .success)
        self.debug(model)
        self.log(model.type.printTag + text)
    }
    
    public func error(_ text: String) {
        let model = LogModel(
            description: text,
            type: .error)
        self.debug(model)
        self.log(model.type.printTag + text)
    }
    
    public func print(_ text: String) {
        let model = LogModel(
            description: text,
            type: .print)
        self.debug(model)
        self.log(model.type.printTag + text)
    }
    
    public func warn(_ text: String) {
        let model = LogModel(
            description: text,
            type: .warning)
        self.debug(model)
        self.log(model.type.printTag + text)
    }
    
    public func debug(_ model: DebuggerModel) {
        self.items.append(model)
        if self.isLocalStorageEnabled {
            Debug.runIfNeeded {
                Storage.save(model)
            }
        }
        guard let viewModel: DebuggerItemViewModel = Debug.factoryViewModel(model: model) else { return }
        self.listenerManager.emit(viewModel)
    }
    
    public func dismissSideMenu(animated flag: Bool, completion: (() -> Void)?) {
        let view: DebuggerView? = DebuggerView.shared
        if flag {
            view?.animateSideMenu(toHide: true, completion: { [weak view] in
                view?.removeFromSuperview()
                completion?()
            })
        } else {
            view?.removeFromSuperview()
        }
    }
    
    func clearLogs() {
        self.items.removeAll()
        if self.isLocalStorageEnabled {
            Debug.runIfNeeded {
                Storage.removeAll()
            }
        }
    }
    
    func emit(event: Event) {
        self.events.emit(event)
    }
    
    func bindDebug(listener: Listener<DebuggerItemViewModel>) {
        self.listenerManager.bind(listener)
    }
    
    func log(_ message: String) {
        Debug.runIfNeeded {
            NSLog(message)
        }
    }
    
    static func runIfNeeded(_ handler: @escaping () -> Void) {
        #if DEBUG
        handler()
        #endif
    }
    
    public static func stringfy(_ any: Any?) -> String {
        if let data = any as? Data {
            if let anyObject = try? JSONSerialization.jsonObject(with: data) {
                return self.stringfy(anyObject)
            }
            if let text = String(data: data, encoding: .utf8) {
                return text
            }
        }
        if let collection = any as? Array<AnyObject> {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: collection, options: [.prettyPrinted]),
                let jsonString = String(data: jsonData, encoding: .utf8) else {
                    return "{\n}"
            }
            return jsonString.replacingOccurrences(of: "\\/", with: "/")
        }
        if let collection = any as? Dictionary<AnyHashable, AnyObject> {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: collection, options: [.prettyPrinted]),
                let jsonString = String(data: jsonData, encoding: .utf8) else {
                    return "{\n}"
            }
            return jsonString.replacingOccurrences(of: "\\/", with: "/")
        }
        return "\(any ?? "null")"
    }
    
    static func factoryViewModel(model: DebuggerModel) -> DebuggerItemViewModel? {
        if let httpRequestModel = model as? DebuggerHTTPRequestModel {
            return DebuggerHTTPRequestCellViewModel(model: httpRequestModel)
        }
        if let simpleLogModel = model as? DebuggerLogModel {
            return DebuggerSimpleLogViewModel(model: simpleLogModel)
        }
        
        return nil
    }
    
}
