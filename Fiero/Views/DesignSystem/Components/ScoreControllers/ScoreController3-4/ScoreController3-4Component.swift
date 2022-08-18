//
//  ScoreController3-4Component.swift
//  Fiero
//
//  Created by Lucas Dimer Justo on 09/08/22.
//

import SwiftUI

struct ScoreController3_4Component: View {
    var foreGroundColor: Color
    var playerName: String
    @Binding var playerScore: Double
    
    @State private var timer: Timer?
    @State var isLongPressing = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                .foregroundColor(foreGroundColor)
            HStack {
                Button(action: {
                    print("tap")
                    if(self.isLongPressing){
                        //End of a longpress gesture, so stop our fastforwarding
                        self.isLongPressing.toggle()
                        self.timer?.invalidate()
                        
                    } else {
                        //Regular tap
                        playerScore -= 1
                    }
                }, label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                    
                })
                .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                    print("long press")
                    self.isLongPressing = true
                    //Fastforward has started
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                        
                        playerScore -= 1
                        
                    })
                })
//                Button {
//                    playerScore -= 1
//                } label: {
//                    Image(systemName: "minus.circle.fill")
//                        .resizable()
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
//                }
                Spacer()
                VStack {
                    Text("\(playerScore, specifier: "%.0f")")
                        .font(Tokens.FontStyle.largeTitle.font())
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                    
                    Text(playerName)
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                }
                Spacer()
                Button(action: {
                    if(self.isLongPressing){
                        //End of a longpress gesture, so stop our fastforwarding
                        self.isLongPressing.toggle()
                        self.timer?.invalidate()
                        
                    } else {
                        //Regular tap
                        self.playerScore += 1
                    }
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                    
                })
                .simultaneousGesture(LongPressGesture(minimumDuration: 0.2).onEnded { _ in
                    self.isLongPressing = true
                    //Fastforward has started
                    self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { _ in
                        
                        self.playerScore += 1
                        
                    })
                })
//                Button {
//                    playerScore += 1
//                } label: {
//                    Image(systemName: "plus.circle.fill")
//                        .resizable()
//                        .frame(width: 40, height: 40)
//                        .foregroundColor(.black)
//                }

            }
            .padding(.horizontal, Tokens.Spacing.xs.value)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .center)
    }
}

struct ScoreController3_4Component_Previews: PreviewProvider {
    static var previews: some View {
        ScoreController3_4Component(foreGroundColor: .yellow, playerName: "Name", playerScore: .constant(0))
    }
}
