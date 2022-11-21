//
//  LeaderboardView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 16/11/22.
//

import Foundation
import SwiftUI

struct LeaderboardView: View {
    
    @Binding var quickChallenge: QuickChallenge
        
    var body: some View {
        HStack {
            if self.quickChallenge.teams.count > 1 {
                //second place
                LeaderboardParticipantView(colorFill: Tokens.Colors.Highlight.one.value, placement: .second, quickChallenge: self.$quickChallenge, teamId:  self.quickChallenge.getRanking()[1].id)
                    .padding(.leading)
            }
            if self.quickChallenge.teams.count > 0 {
                //first place
                LeaderboardParticipantView(colorFill: Tokens.Colors.Highlight.three.value, placement: .first, quickChallenge: self.$quickChallenge, teamId:  self.quickChallenge.getRanking()[0].id)
                    .padding(.vertical)
                    .padding(.horizontal)
            }
            
            if self.quickChallenge.teams.count > 2 {
                //third place
                LeaderboardParticipantView(colorFill: Tokens.Colors.Highlight.two.value, placement: .third, quickChallenge: self.$quickChallenge, teamId:  self.quickChallenge.getRanking()[2].id)
                .padding(.trailing)
            }
        }
        .environment(\.colorScheme, .dark)
        .background(Tokens.Colors.Neutral.Low.dark.value)
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
    @Binding var quickChallenge: QuickChallenge
    var teamId: String
    
    var body: some View {
        
        let name: String = self.quickChallenge.teams.first(where: { $0.id == teamId})?.name
        ?? ""
        VStack {
            Circle()
                .frame(width: UIScreen.main.bounds.width * 0.25, height: UIScreen.main.bounds.width * 0.25)
                .foregroundColor(self.colorFill)
                .overlay(content: {
                    Text(self.placement == .first ? Member.getImage(playerName: "player2") : (self.placement == .second ? Member.getImage(playerName: "") : Member.getImage(playerName: "player3")))
                        .font(.system(size: 48))
                        .overlay(content: {
                            Text(self.placement == .first ? "🥇" : (self.placement == .second ? "🥈" : "🥉"))
                                .font(.system(size: 28))
                                .padding(.top, 64)
                        })
                })
            
            Text(name.components(separatedBy: " ").first ?? "")
                .padding(Tokens.Spacing.quarck.value)
            
            Text(String(format: "%.0f", self.quickChallenge.teams.first(where: { $0.id == teamId})?.getTotalScore() ?? -1.0))
                .bold()
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(quickChallenge: .constant(QuickChallenge(id: "", name: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))))
            .cornerRadius(Tokens.Border.BorderRadius.small.value)
    }
}
