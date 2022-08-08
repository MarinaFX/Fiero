//
//  ChallengesListScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/07/22.
//

import SwiftUI

struct ChallengesListScreenView: View {
    @Environment(\.rootPresentationMode) var rootPresentationMode
    
    @StateObject var quickChallengeViewModel: QuickChallengeViewModel = QuickChallengeViewModel()
    @State var quickChallenges: [QuickChallenge] = []
    @State var isPresented: Bool = false
    
    var body: some View {
        NavigationView {
            if self.quickChallenges.count > 0 {
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
                        NavigationLink(destination: QCCategorySelectionView(), isActive: $isPresented, label: {
                            Button(action: {
                                isPresented = true
                            }, label: {
                                Image(systemName: "plus")
                                    .font(Tokens.FontStyle.title2.font(weigth: .bold))
                                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            })
                        })
                    }
                }
            }
            else {
                EmptyChallengesView()
                
                .navigationTitle("Seus desafios")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: QCCategorySelectionView(), isActive: $isPresented, label: {
                            Button(action: {
                                isPresented = true
                            }, label: {
                                Image(systemName: "plus")
                                    .font(Tokens.FontStyle.title2.font(weigth: .bold))
                                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            })
                        })
                    }
                }
            }
        }
        .onAppear(perform: {
            self.quickChallengeViewModel.getUserChallenges()
        })
        .environment(\.colorScheme, .dark)
        .onChange(of: self.quickChallengeViewModel.challengesList, perform: { quickChallenges in
            self.quickChallenges = quickChallenges
        })
        .navigationViewStyle(.stack)
        .environment(\.rootPresentationMode, self.$isPresented)

    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView()
    }
}
