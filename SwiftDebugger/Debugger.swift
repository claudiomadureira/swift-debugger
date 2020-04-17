//
//  Debugger.swift
//  SwiftDebugger
//
//  Created by Claudio Madureira Silva Filho on 4/8/20.
//  Copyright © 2020 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

public class Debugger: NSObject {
    
    public static let shared = Debugger()
    
    public var environments: [String] = []
    public var indexSelectedEnvironment: Int = 0
    public var localizations: [String] = []
    public var indexSelectedLocalization: Int = 0
    public var labelTextIdentifierIsHidden: Bool = true
    
    var eventHandler: ((Event) -> Void)?
    
    public enum Event {
        case didChangeEnvironment(String)
        case didChangeLocalization(String)
        case didSetLabelsTextIdentifierHidden(Bool)
    }
    
    public func setUp(environments: [String],
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
    
    public func emit(event: Event) {
        self.eventHandler?(event)
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
    
}
