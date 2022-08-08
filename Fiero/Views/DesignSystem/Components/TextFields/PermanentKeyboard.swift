//
//  PermanentKeyboard.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import UIKit
import SwiftUI

//MARK: PermanentKeyboard
struct PermanentKeyboard: UIViewRepresentable {
    //MARK: - Variables Setup
    @Binding var text: String
    
    var keyboardType: UIKeyboardType = .default
    var onCommit: () -> Void = {}
    
    typealias UIViewType = UITextField
    
    //MARK: - Coordinator
    class Coordinator: NSObject, UITextFieldDelegate {
        //MARK: - Variables Setup
        var parent: PermanentKeyboard
        var didBecomeFirstResponder: Bool = false
        
        //MARK: - Init
        init(_ parent: PermanentKeyboard) {
            self.parent = parent
        }
        
        //MARK: - UITextFieldDelegate
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? "nao funcionou"
            }
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.parent.text = textField.text ?? "Error on \(#function)"
            self.parent.didCommit()
            textField.isEnabled = false
            textField.resignFirstResponder()

            return true
        }
    }
    
    //MARK: - UIViewRepresentable functions
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    //TODO: Adjust UIFont to support Dynamic Types
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2000))
                
        textField.textColor = UIColor(cgColor: Tokens.Colors.Neutral.High.pure.value.cgColor!)
        textField.layer.backgroundColor = UIColor.clear.cgColor
        
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        textField.font = font
        
        textField.keyboardType = self.keyboardType
        textField.returnKeyType = .done
        
        textField.delegate = context.coordinator
        textField.addDoneButtonOnKeyboard()
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        
        if !uiView.isFirstResponder && !context.coordinator.didBecomeFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
            context.coordinator.didBecomeFirstResponder = true
        }
        
        uiView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiView.textAlignment = NSTextAlignment.center
    }
    
    func didCommit() {
        onCommit()
    }
}

//MARK: UITextField Extensions
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
