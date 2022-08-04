//
//  ChallengesListScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/07/22.
//

import SwiftUI

struct ChallengesListScreenView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var challengesListViewModel: ChallengeListViewModel = ChallengeListViewModel()
    @State var quickChallenges: [QuickChallenge] = []
    @State var showNextScreen: Bool = false
    
    
    var body: some View {
        NavigationView {
            ListWithoutSeparator(0..<self.quickChallenges.count, id: \.self) { index in
                ChallengeCellComponent(style: .md3([.lose, .lose, .win]),
                                       challengeName: quickChallenges[index].name,
                                       player1: quickChallenges[index].player1,
                                       player2: quickChallenges[index].player2)
            }
            .padding(.top, Tokens.Spacing.xl.value)
            .makeDarkModeFullScreen()
            
            .navigationTitle("Seus desafios")
            .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: EmptyChallengesView(), isActive: $showNextScreen, label: {
                        Button(action: {
                            showNextScreen = true
                        }, label: {
                            Image(systemName: "plus")
                                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        })
                    })
                }
            }
        }
        .environment(\.colorScheme, .dark)
        .onChange(of: self.challengesListViewModel.quickChallengesList, perform: { quickChallenges in
                self.quickChallenges = quickChallenges
            })
        .onAppear {
            quickChallenges = [QuickChallenge(name: "Perder calorias", player1: "Bianca", player2: "Clara"),
                               QuickChallenge(name: "Malabarismo", player1: "Pedro", player2: "Bruno"),
                               QuickChallenge(name: "Chute a gol", player1: "Nicole", player2: "Laís"),
                               QuickChallenge(name: "Correr 10km", player1: "Arthur", player2: "Eliana")]
        }
    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView()
    }
}
