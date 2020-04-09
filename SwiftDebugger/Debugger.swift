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
    public var localizations: [String] = []
    public var labelTextIdentifierIsHidden: Bool = true
    var eventHandler: ((Event) -> Void)?
    
    enum Event {
        case didChangeEnvironment(String)
        case didChangeLocalization(String)
        case didSetLabelsTextIdentifierHidden(Bool)
    }
    
    func setUp(environments: [String],
               localizations: [String],
               showTextIdentifierOnLabels: Bool,
               eventHandler: @escaping (Event) -> Void) {
        self.environments = environments
        self.localizations = localizations
        self.labelTextIdentifierIsHidden = !showTextIdentifierOnLabels
        self.eventHandler = eventHandler
    }
    
    func emit(event: Event) {
        self.eventHandler?(event)
    }
    
}
