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
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.inputAccessoryView = self.toolbarView
        self.delegate = self
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
    }
    
    

}

extension JSONWriterTextView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let isReturnPressed: Bool = text == "\n"
        if isReturnPressed {
            let lines: [String] = (textView.text ?? "").components(separatedBy: "\n")
            dump(lines)
            // Finding cursor position in lines
            var index: Int = 0
            var count: Int = 0
            for (i, line) in lines.enumerated() {
                print("Line \(i): \(line.count)")
                let next: Int = count + line.count + 1
                if range.location <= next {
                    index = i
                    break
                }
                count = next
            }
            print(index)
            
            let breakLine: String = lines[index]
            var spacing: String = ""
            for char in breakLine {
                if String(char) == " " {
                    spacing.append(" ")
                } else {
                    break
                }
            }
            var sufix: String = "\"\""
            let oldRange = textView.selectedTextRange
            let isJSON: Bool = breakLine.lastString == "{"
            let isMiddleJSON: Bool = lines.count > (index + 1) && lines[index + 1].contains("\"")
            if isJSON {
                sufix.append("\n" + spacing + "}\(isMiddleJSON ? "," : "")")
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
            if let _oldRange = oldRange,
                let position = textView.position(from: _oldRange.start, offset: spacing.count + prefix.count + (isJSON ? 2 : (isMiddleJSON ? (sufix.count - 2) : sufix.count) - 2)) {
                textView.selectedTextRange = textView.textRange(from: position, to: position)
            }
            return false
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
                print("\(error)")
            }
        }
    }
    
}
