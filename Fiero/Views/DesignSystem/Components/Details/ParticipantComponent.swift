//
//  ParticipantComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct ParticipantComponent: View {
    
    @State var style: ParticipantStyles
    @State var name: String
    @State var pointsOrTime: String?
    
    var body: some View {
        VStack(spacing: style.spacing) {
            ZStack {
                if style == .participantLooser {
                    Circle()
                        .frame(width: 97, height: 97)
                        .foregroundColor(style.backgroundImage)
                        .saturation(0)
                    Text(style.image)
                        .font(.system(size: 55))
                        .saturation(0)
                }
                else {
                    Circle()
                        .frame(width: 97, height: 97)
                        .foregroundColor(style.backgroundImage)
                    Text(style.image)
                        .font(.system(size: 55))
                }
            }
            Text(name)
                .font(style.textFont)
                .foregroundColor(style.textAndPointsColor)
            
            Text(pointsOrTime ?? "")
                .font(style.pointsFont)
                .foregroundColor(style.textAndPointsColor)
        }
    }
}

struct ParticipantComponent_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantComponent(style: .participantLooser, name: "Naty", pointsOrTime: "100")
    }
}
