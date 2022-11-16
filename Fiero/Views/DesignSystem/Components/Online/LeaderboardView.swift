//
//  LeaderboardView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 16/11/22.
//

import Foundation
import SwiftUI

struct LeaderboardView: View {
        
    var body: some View {
        HStack {
            LeaderboardParticipantView(colorFill: Tokens.Colors.Highlight.one.value, placement: .second)
            
            LeaderboardParticipantView(colorFill: Tokens.Colors.Highlight.three.value, placement: .first)
            
            LeaderboardParticipantView(colorFill: Tokens.Colors.Highlight.two.value, placement: .third)
        }
        .environment(\.colorScheme, .dark)
        .background(Tokens.Colors.Neutral.Low.pure.value)
    }
}

struct LeaderboardParticipantView: View {
    enum Placement {
        case first
        case second
        case third
    }
    var colorFill: Color
    var placement: Placement = .first
    
    var body: some View {
        VStack {
            Circle()
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .foregroundColor(self.colorFill)
                .overlay(content: {
                    Text(Member.getImage(playerName: ""))
                        .font(.system(size: 48))
                        .overlay(content: {
                            Text(self.placement == .first ? "🥇" : (self.placement == .second ? "🥈" : "🥉"))
                                .font(.system(size: 28))
                                .padding(.top, 64)
                        })
                })
            
            Text("Bru")
                .padding(Tokens.Spacing.quarck.value)
            
            Text("9.666")
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
            .cornerRadius(Tokens.Border.BorderRadius.small.value)
    }
}
