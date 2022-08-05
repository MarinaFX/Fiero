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
                CustomTitleImageListRow(teste: quickChallenges[index].name)
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
    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView()
    }
}
