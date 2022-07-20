//
//  PermanentKeyboard.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import UIKit
import SwiftUI

struct PermanentKeyboard: UIViewRepresentable {
    @Binding var text: String
    
    var keyboardType: UIKeyboardType = .default
    var onCommit: () -> Void = {}
    
    typealias UIViewType = UITextField
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PermanentKeyboard
        
        init(_ parent: PermanentKeyboard) {
            self.parent = parent
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            parent.didCommit()
            
            return true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2000))
                
        textField.textColor = UIColor(cgColor: Tokens.Colors.Neutral.High.pure.value.cgColor!)
        textField.layer.backgroundColor = UIColor.clear.cgColor
        
        textField.keyboardType = self.keyboardType
        textField.returnKeyType = .done
        
        textField.text = text
        print(text)
        
        textField.delegate = context.coordinator
        textField.addDoneButtonOnKeyboard()
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        print(text)
        
        if !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    func didCommit() {
        onCommit()
    }
}

extension UITextField {
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action: #selector(self.didTapDismissButton))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func didTapDismissButton() {
        self.resignFirstResponder()
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
