//
//  Debug.swift
//
//  Created by Claudio Madureira Silva Filho on 4/8/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

public enum Debug {
    
    public static var environments: [String] = [] {
        didSet {
            self.indexSelectedEnvironment = 0
        }
    }
    
    public static var indexSelectedEnvironment: Int = 0
    
    public static var localizations: [String] = [] {
        didSet {
            self.indexSelectedLocalization = 0
        }
    }
    
    public static var indexSelectedLocalization: Int = 0
    public static var isVisibleIdentifier: Bool?
    public static let events: Signal<Event> = .init()
    
    public static var localSettings: [String: Any]?
    
    private(set) static var items: [DebuggerModel] = []
    
    static var mappedItems: [DebuggerItemViewModel] {
        return self.items.compactMap { self.factoryViewModel(model: $0) }
    }
    
    static var listenerManager = ListenerManager<DebuggerItemViewModel>()
    
    public enum Event {
        case didChangeEnvironment(String)
        case didChangeLocalization(String)
        case didChangeIdentifierVisibility(Bool)
        case didChangeLocalSettings([String: Any]?)
    }
    
    public static func errorDecoding<Model: Decodable>(_ error: Error, data: Data, modelToConvert: Model.Type) {
        guard let _error = error as? DecodingError else { return }
        let model = DebuggerDecodingErrorModel(error: _error, model: modelToConvert, data: data, type: .decodingError)
        self.debug(model)
        let prettyJSONText = self.stringfy(data)
        self.log(model.type.printTag + model.description + "\nInput data:\n" + prettyJSONText)
    }
    
    public static func success(_ text: String) {
        let model = LogModel(
            description: text,
            type: .success)
        self.debug(model)
        self.log(model.type.printTag + text)
    }
    
    public static func error(_ text: String) {
        let model = LogModel(
            description: text,
            type: .error)
        self.debug(model)
        self.log(model.type.printTag + text)
    }
    
    public static func print(_ text: String) {
        let model = LogModel(
            description: text,
            type: .print)
        self.debug(model)
        self.log(model.type.printTag + text)
    }
    
    public static func warn(_ text: String) {
        let model = LogModel(
            description: text,
            type: .warning)
        self.debug(model)
        self.log(model.type.printTag + text)
    }
    
    public static func debug(_ model: DebuggerModel) {
        self.items.append(model)
        guard let viewModel: DebuggerItemViewModel = self.factoryViewModel(model: model) else { return }
        self.listenerManager.emit(viewModel)
    }
    
    public static func dismissSideMenu(animated flag: Bool, completion: (() -> Void)?) {
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
    
    static func clearLogs() {
        self.items.removeAll()
    }
    
    static func emit(event: Event) {
        self.events.emit(event)
    }
    
    static func bindDebug(listener: Listener<DebuggerItemViewModel>) {
        self.listenerManager.bind(listener)
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
    
    static func log(_ meesage: String) {
        self.runIfNeeded {
            NSLog(meesage)
        }
    }
    
    static func runIfNeeded(_ handler: @escaping () -> Void) {
        #if DEBUG
        handler()
        #endif
    }
    
}
