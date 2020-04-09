//
//  Button.swift
//
//  Created by Claudio Madureira Silva Filho on 10/12/18.
//  Copyright © 2018 Claudio Madureira Silva Filho. All rights reserved.
//

import UIKit

public enum ButtonState {
    case highlighted
    case normal
    
    public var alpha: CGFloat {
        return self == .normal ? 1 : 0.4
    }
}

open class Button: UIButton {
    
    private(set) public var currentState: ButtonState = .normal
    private var didChangeState: ((Button, ButtonState) -> Void)?
    private var didTouchInside: ((Button) -> Void)?
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchDragInside), for: .touchDragInside)
        self.addTarget(self, action: #selector(didTouchUpOutside), for: .touchDragOutside)
        self.addTarget(self, action: #selector(didTouchUpOutside), for: .touchCancel)
        self.addTarget(self, action: #selector(didTouchUpOutside), for: .touchDragExit)
    }
    
    public func onChangeState(_ handler: @escaping (Button, ButtonState) -> Void) {
        self.didChangeState = handler
    }
    
    public func onTouchUpInside(_ handler: @escaping (Button) -> Void) {
        self.didTouchInside = handler
    }
    
    public func perform(state: ButtonState) {
        self.currentState = state
        self.didChangeState?(self, state)
    }
    
    @objc
    private func didTouchDown() {
        self.perform(state: .highlighted)
    }
    
    @objc
    private func didTouchDragInside() {
        self.perform(state: .highlighted)
    }
    
    @objc
    private func didTouchUpInside() {
        self.perform(state: .normal)
        self.didTouchInside?(self)
    }
    
    @objc
    private func didTouchUpOutside() {
        self.perform(state: .normal)
    }
    
}
