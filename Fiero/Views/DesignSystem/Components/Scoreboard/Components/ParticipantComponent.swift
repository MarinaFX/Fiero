//
//  ParticipantComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct ParticipantComponent: View {
    
    @State var style: ParticipantStyles
    @Binding var name: String
    @Binding var score: Double
    
    var body: some View {
        VStack(spacing: style.spacing) {
            ZStack {
                Circle()
                    .foregroundColor(Member.getColor(playerName: name))
                    //.foregroundColor(Color(color))
                    .frame(width: style.width, height: style.width)
                    .saturation(style.saturation)
                Text(Member.getImage(playerName: name))
                    .font(style.iconFont)
                    .saturation(style.saturation)
            }
            Text(name)
                .font(style.textFont)
                .foregroundColor(style.textAndPointsColor)
            
            Text("\(score, specifier: "%.0f")")
                .font(style.pointsFont)
                .foregroundColor(style.textAndPointsColor)
        }
    }
}

struct ParticipantComponent_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantComponent(style: ParticipantStyles.participantDefault(isSmall: true), name: .constant("naty"), score: .constant(0))
    }
}
