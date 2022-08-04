//
//  GroupComponent.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI

struct GroupComponent: View {
    
    @State var style: [ParticipantStyles]
    @State var name: [String]
    @State var pointsOrTime: [String]?
    
    var body: some View {
        HStack(spacing: Tokens.Spacing.xxxs.value) {
            ForEach(0..<name.count, id: \.self) { index in
                ParticipantComponent(style: style[index], name: name[index], pointsOrTime: pointsOrTime?[index])
            }
        }
        .padding(.all)
        .background(RoundedRectangle(cornerRadius: 11).fill(Color.white))
        
    }
}

struct GroupComponent_Previews: PreviewProvider {
    static var previews: some View {
        GroupComponent(style: [.participantDefault, .participantDefault], name: ["Clarice", "Marina"])
    }
}
