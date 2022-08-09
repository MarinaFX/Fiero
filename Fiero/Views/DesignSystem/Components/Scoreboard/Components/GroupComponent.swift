//
//  GroupComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct GroupComponent: View {
    @State var scoreboard: Bool
    @State var style: [ParticipantStyles]
    @State var element: [ElementsStyles]
    @State var name: [String]
    @State var pointsOrTime: [String]?
    
    var body: some View {
        ZStack {
            Color.black
            
            if scoreboard {
                ZStack {
                    RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.small.value)
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    
                    HStack(spacing: Tokens.Spacing.nano.value) {
                        ForEach(0..<name.count, id: \.self) { index in
                            ParticipantComponent(style: style[index], element: element[index], name: name[index], pointsOrTime: pointsOrTime?[index])
                        }
                    }
                    
                }
            }
            else {
                HStack(spacing: Tokens.Spacing.xxxs.value) {
                    ForEach(0..<name.count, id: \.self) { index in
                        ParticipantComponent(style: style[index], element: element[index], name: name[index], pointsOrTime: pointsOrTime?[index])
                    }
                }
                .padding(.all)
                .background(RoundedRectangle(cornerRadius: 11).fill(Color.white))
            }
        }
    }
}

struct GroupComponent_Previews: PreviewProvider {
    static var previews: some View {
        GroupComponent(scoreboard: true, style: [.participantDefault(isSmall: true), .participantDefault(isSmall: true), .participantDefault(isSmall: true)], element: [.one, .two, .three], name: ["Bru", "Klaus", "Sol"], pointsOrTime: ["22", "12", "43"])
    }
}
