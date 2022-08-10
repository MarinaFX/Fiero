//
//  ParticipantComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct ParticipantComponent: View {
    
    @State var style: ParticipantStyles
    @State var element: ElementsStyles
    @State var name: String
    @State var pointsOrTime: String?
//    @State var image: String
//    @State var color: String
    
    var body: some View {
        VStack(spacing: style.spacing) {
            ZStack {
                Circle()
                    .foregroundColor(Color(element.color))
                    //.foregroundColor(Color(color))
                    .frame(width: style.width, height: style.width)
                    .saturation(style.saturation)
                Text(element.image)
                    .font(style.iconFont)
                    .saturation(style.saturation)
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
        ParticipantComponent(style: .participantDefault(isSmall: true), element: .one, name: "Naty", pointsOrTime: "100")
    }
}
