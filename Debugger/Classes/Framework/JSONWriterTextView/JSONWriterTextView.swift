//
//  JSONWriterTextView.swift
//  Debugger
//
//  Created by Claudio Madureira Silva Filho on 6/8/20.
//

import UIKit


class JSONWriterTextView: UITextView {
    
    private lazy var toolbarView: JSONWriterToolbarView = {
        let view = JSONWriterToolbarView.xib()
        view.setJSON(valid: true)
        view.setButtonDone(enabled: true)
        view.onDonePressed { [weak self] (toolBar) in
            self?.resignFirstResponder()
        }
        view.onQuotationMarksPressed { [weak self] (toolBar) in
            guard let self = self else { return }
            if let oldRange = self.selectedTextRange {
                self.insertText("\"\"")
                if let position = self.position(from: oldRange.start, offset: 1) {
                    self.selectedTextRange = self.textRange(from: position, to: position)
                }
            }
        }
        view.onJSONEmptyPressed { [weak self] (toolBar) in
            guard let self = self else { return }
            if let oldRange = self.selectedTextRange {
                self.insertText("{}")
                if let position = self.position(from: oldRange.start, offset: 1) {
                    self.selectedTextRange = self.textRange(from: position, to: position)
                }
            }
        }
        view.onJSONFilledPressed { [weak self] (toolBar) in
            guard let self = self else { return }
            let (lines, spacing, _, index) = self.splitTextInLinesOfText()
            if let oldRange = self.selectedTextRange {
                let isMiddleJSON: Bool = lines.count > (index + 1) && lines[index + 1].contains("\"")
                self.insertText("{\n\(spacing)  \"\" :\n\(spacing)}\(isMiddleJSON ? "," : "")")
                if let position = self.position(from: oldRange.start, offset: 5 + spacing.count) {
                    self.selectedTextRange = self.textRange(from: position, to: position)
                }
            }
        }
        return view
    }()
    
    private var onTextDidChange: ((JSONWriterTextView) -> Void)?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.inputAccessoryView = self.toolbarView
        self.delegate = self
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
    
    private func clearIf(charBefore charB: String, charAfter charA: String) -> Bool {
        let charBefore: String = ((self.text ?? "") as NSString).substring(with: NSRange(location: self.selectedRange.location - 1, length: 1))
        let charAfter: String = ((self.text ?? "") as NSString).substring(with: NSRange(location: self.selectedRange.location, length: 1))
        if charBefore == charB && charAfter == charA {
            let range = NSRange(location: self.selectedRange.location - 1, length: 2)
            let newText = ((self.text ?? "") as NSString).replacingCharacters(in: range, with: "")
            if let oldRange = self.selectedTextRange {
                self.text = newText
                self.textViewDidChange(self)
                if let position = self.position(from: oldRange.start, offset: -1) {
                    self.selectedTextRange = self.textRange(from: position, to: position)
                    return true
                }
            }
        }
        return false
    }
    
    private func splitTextInLinesOfText() -> ([String], String, String, Int) {
        let lines: [String] = (self.text ?? "").components(separatedBy: "\n")
        
        // Finding cursor position in lines
        var index: Int = 0
        var count: Int = 0
        for (i, line) in lines.enumerated() {
            let next: Int = count + line.count + 1
            if self.selectedRange.location <= next {
                index = i
                break
            }
            count = next
        }
        
        let breakLine: String = lines[index]
        var spacing: String = ""
        for char in breakLine {
            if String(char) == " " {
                spacing.append(" ")
            } else {
                break
            }
        }
        return (lines, spacing, breakLine, index)
    }
    
    func onTextDidChange(handler: @escaping (JSONWriterTextView) -> Void) {
        self.onTextDidChange = handler
    }
    
}

extension JSONWriterTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isReturnPressed: Bool = text == "\n"
        if isReturnPressed {
            var (lines, spacing, breakLine, index): ([String], String, String, Int) = self.splitTextInLinesOfText()
            var sufix: String = "\"\""
            let oldRange = textView.selectedTextRange
            let isJSON: Bool = breakLine.lastString == "{" || breakLine.lastString == "}"
            let isJSONAlreadyClosed: Bool = breakLine.lastString == "}"
            let isMiddleJSON: Bool = lines.count > (index + 1) && lines[index + 1].contains("\"")
            if isJSON {
                let closeJSON: String = isJSONAlreadyClosed ? "" : "}"
                sufix.append(" :\n" + spacing + "\(closeJSON)\(isMiddleJSON ? "," : "")")
                spacing.append("  ")
            } else if isMiddleJSON {
                sufix.append(" : ,")
            } else {
                sufix.append(" :")
            }
            let currentText: String = textView.text ?? ""
            let isLine: Bool = !(breakLine.lastString != ",")
            var prefix: String = !isLine && !isJSON ? "," : ""
            let newText: String = (currentText as NSString).replacingCharacters(in: range, with: prefix + text + spacing + sufix)
            textView.text = newText
            self.textViewDidChange(textView)
            if let _oldRange = oldRange,
                let position = textView.position(from: _oldRange.start, offset: spacing.count + prefix.count + (isJSON ? 2 : (isMiddleJSON ? (sufix.count - 2) : sufix.count) - 2)) {
                textView.selectedTextRange = textView.textRange(from: position, to: position)
            }
            return false
        }
        let isClearPressed = text == ""
        if isClearPressed {
            if self.clearIf(charBefore: "{", charAfter: "}") {
                return false
            }
            if self.clearIf(charBefore: "\"", charAfter: "\"") {
                return false
            }
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text: String = textView.text ?? ""
        if let data = text.data(using: .utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                self.toolbarView.setJSON(valid: true)
                self.toolbarView.setButtonDone(enabled: true)
            } catch let error {
                self.toolbarView.setJSON(valid: false)
                self.toolbarView.setButtonDone(enabled: false)
            }
        } else {
            self.toolbarView.setJSON(valid: false)
            self.toolbarView.setButtonDone(enabled: false)
        }
        self.onTextDidChange?(self)
    }
    
}
