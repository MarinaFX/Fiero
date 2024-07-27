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
        
        public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            return range.location < 13
        }
        
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
            DispatchQueue.main.async {
                self.parent.text = textField.text ?? "Error on \(#function)"
            }
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
        
        let font = UIFont.preferredFont(forTextStyle: .title1)
        textField.font = font
        
        textField.keyboardType = self.keyboardType
        textField.returnKeyType = .done
        
        textField.delegate = context.coordinator
        
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