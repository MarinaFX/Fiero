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
    
    typealias UIViewType = UITextField
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: PermanentKeyboard
        
        init(_ parent: PermanentKeyboard) {
            self.parent = parent
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2000))
        
        //textField.borderStyle = UITextField.BorderStyle.roundedRect
        
//        textField.tintColor = .
        textField.textColor = UIColor(cgColor: Tokens.Colors.Neutral.Low.pure.value.cgColor!)
        textField.layer.backgroundColor = UIColor.clear.cgColor
        
        textField.delegate = context.coordinator
        textField.addDoneButtonOnKeyboard()
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
        if !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        }
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

extension UITextField {
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.didTapDoneButton))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func didTapDoneButton() {
        self.resignFirstResponder()
    }
}
