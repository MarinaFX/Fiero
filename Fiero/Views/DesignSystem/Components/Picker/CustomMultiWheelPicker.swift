//
//  CustomMultiWheelPicker.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import SwiftUI

struct CustomMultiWheelPicker: View {
    
    @Binding var hourSelection: Int
    @Binding var minuteSelection: Int
    @Binding var secondSelection: Int
    
    var hours = [Int](0..<25)
    var minutes = [Int](0..<60)
    var seconds = [Int](0..<60)
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Picker(selection: self.$hourSelection, content: {
                    ForEach(0 ..< self.hours.count, id: \.self) { index in
                        Text("\(self.hours[index]) h")
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .tag(index)
                    }
                }, label: {
                    Text("Hours")
                })
                .pickerStyle(.wheel)
                .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
                .compositingGroup()
                .clipped()
                
                Picker(selection: self.$minuteSelection, content: {
                    ForEach(0 ..< self.minutes.count, id: \.self) { index in
                        Text("\(self.minutes[index]) m")
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .tag(index)
                    }
                }, label: {
                    Text("Minutes")
                })
                .pickerStyle(.wheel)
                .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
                .compositingGroup()
                .clipped()
                
                Picker(selection: self.$secondSelection, content: {
                    ForEach(0 ..< self.seconds.count, id: \.self) { index in
                        Text("\(self.seconds[index]) s")
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .tag(index)
                    }
                }, label: {
                    Text("Seconds")
                })
                .pickerStyle(.wheel)
                .frame(width: geometry.size.width/3, height: geometry.size.height, alignment: .center)
                .compositingGroup()
                .clipped()
            }
            .makeDarkModeFullScreen()
        }
    }
}

struct CustomMultiWheelPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomMultiWheelPicker(hourSelection: .constant(1), minuteSelection: .constant(1), secondSelection: .constant(5))
    }
}
