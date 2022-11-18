//
//  CreationFlowTextViewComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 18/11/22.
//
import Foundation
import UIKit
import SwiftUI

struct CreationFlowTextViewComponent: UIViewRepresentable {
    @Binding var text: String
    
    @State var style: CreationFlowTextViewStyles
    
    var onCommit: () -> Void = {}
    
    typealias UIViewType = UITextView
    
    class Coordinator: NSObject, UITextViewDelegate {
        var style: CreationFlowTextViewStyles
        var parent: CreationFlowTextViewComponent
        var didBecomeFirstResponder: Bool = false
        
        init(parent: CreationFlowTextViewComponent, style: CreationFlowTextViewStyles) {
            self.parent = parent
            self.style = style
        }
        
        public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if style == .name {
                return range.location < 50
            }
            else {
                return range.location < 18
            }
        }
        
        func textViewDidChangeSelection(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.text = textView.text ?? "didn't work"
            }
        }
        
        func textViewShouldReturn(_ textView: UITextView) -> Bool {
            DispatchQueue.main.async {
                self.parent.text = textView.text ?? "Error on \(#function)"
            }
            self.parent.didCommit()
            textView.isEditable = false
            textView.resignFirstResponder()
            
            return true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self, style: style)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: UIScreen.main.bounds.width - 50,
                                                height: UIScreen.main.bounds.height/4))
        textView.font = style.textFont
        textView.textColor = UIColor(cgColor: style.textColor)
        textView.layer.backgroundColor = style.backgroundColor
        textView.keyboardType = style.keyboardType
        textView.returnKeyType = style.returnKeyType
        textView.delegate = context.coordinator
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        
        if !uiView.isFirstResponder && !context.coordinator.didBecomeFirstResponder {
            DispatchQueue.main.async {
                uiView.becomeFirstResponder()
            }
            context.coordinator.didBecomeFirstResponder = true
        }
        uiView.setContentHuggingPriority(.defaultLow, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiView.adjustsFontForContentSizeCategory = true
        uiView.textAlignment = NSTextAlignment.center
    }
    
    func didCommit() {
        onCommit()
    }
}
