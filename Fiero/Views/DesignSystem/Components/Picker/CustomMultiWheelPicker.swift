//
//  CustomMultiWheelPicker.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI
import UIKit

//MARK: CustomPickerView
struct CustomPickerView: UIViewRepresentable {
    //MARK: - Variables Setup
    @Binding var valueSelection: Int
    @Binding var measureSelection: String

    var numberOfComponents: Int
    var seconds: [Int]
    var minutes: [Int]
    var goalMeasure: [String]
    
    typealias UIViewType = UIPickerView
    
    //MARK: - Coordinator
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        var parent: CustomPickerView
        
        //MARK: - Init
        init(_ parent: CustomPickerView) {
            self.parent = parent
        }
        
        //MARK: - UIPickerViewDataSource
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return self.parent.numberOfComponents
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return component == 0 ? 60 : 2
        }
        
        //MARK: - UIPickerViewDelegate
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            if component == 0 { return String(self.parent.seconds[row + 1]) }
            return self.parent.goalMeasure[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if component == 0 { self.parent.valueSelection = self.parent.seconds[row + 1] }
            if component == 1 { self.parent.measureSelection = self.parent.goalMeasure[row] }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UIPickerView {
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4))
        
        
        
        pickerView.delegate = context.coordinator
        pickerView.dataSource = context.coordinator
        
        return pickerView
    }
    
    func updateUIView(_ uiView: UIPickerView, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
}

