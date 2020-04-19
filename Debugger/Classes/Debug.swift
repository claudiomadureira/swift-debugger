//
//  Debug.swift
//
//  Created by Claudio Madureira Silva Filho on 4/8/20.
//  Copyright © 2020. All rights reserved.
//

import UIKit

public enum Debug {
    
    public static var environments: [String] = []
    public static var indexSelectedEnvironment: Int = 0
    public static var localizations: [String] = []
    public static var indexSelectedLocalization: Int = 0
    public static var labelTextIdentifierIsHidden: Bool = true
    public static var items: [DebuggerModel] = []
    
    static var mappedItems: [DebuggerItemViewModel] {
        return self.items.map { self.factoryViewModel(model: $0) }
    }
    
    static var eventHandler: ((Event) -> Void)?
    static var listenerManager = ListenerManager<DebuggerItemViewModel>()
    
    public enum Event {
        case didChangeEnvironment(String)
        case didChangeLocalization(String)
        case didSetLabelsTextIdentifierHidden(Bool)
    }
    
    public static func setUp(environments: [String],
                      selectedEnvironmentAt indexEnvironment: Int,
                      localizations: [String],
                      selectedLocalizationAt indexLocalization: Int,
                      showTextIdentifierOnLabels: Bool,
                      eventHandler: @escaping (Event) -> Void) {
        self.environments = environments
        self.indexSelectedEnvironment = indexEnvironment
        self.localizations = localizations
        self.indexSelectedLocalization = indexLocalization
        self.labelTextIdentifierIsHidden = !showTextIdentifierOnLabels
        self.eventHandler = eventHandler
    }
    
    public static  func debug(_ model: DebuggerModel) {
        self.items.append(model)
        let viewModel: DebuggerItemViewModel = self.factoryViewModel(model: model)
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
    
    static func emit(event: Event) {
        self.eventHandler?(event)
    }
    
    static func bindDebug(listener: Listener<DebuggerItemViewModel>) {
        self.listenerManager.bind(listener)
    }
    
    static func factoryViewModel(model: DebuggerModel) -> DebuggerItemViewModel {
        if let httpRequestModel = model as? DebuggerHTTPRequestModel {
            return DebuggerHTTPRequestCellViewModel(model: httpRequestModel)
        }
        return DebuggerItemViewModel()
    }

}