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
            VStack {
                if self.quickChallenges.count > 0 {
                    if #available(iOS 15.0, *) {
                        ListWithoutSeparator(0..<self.quickChallenges.count, id: \.self) { index in
                            CustomTitleImageListRow(teste: quickChallenges[index].name)
                        }
                        .refreshable {
                            self.quickChallengeViewModel.getUserChallenges()
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                        .listStyle(.plain)
                    } else {
                        //TODO: Refreshable list for iOS 14
                        ListWithoutSeparator(0..<self.quickChallenges.count, id: \.self) { index in
                            CustomTitleImageListRow(teste: quickChallenges[index].name)
                        }
                        .ignoresSafeArea(.all, edges: .bottom)
                        .listStyle(.plain)
                    }
                }
                else {
                    EmptyChallengesView()
                }
            }
            
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                        NavigationLink(destination: QCCategorySelectionView(),
                                       isActive: $isPresented,
                                       label: {
                            Button(action: {
                                isPresented = true
                            }, label: {
                                Image(systemName: "plus")
                                    .font(Tokens.FontStyle.title2.font(weigth: .bold))
                                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            })
                        })
                    })
            })
            .navigationTitle("Seus desafios")
                .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
        }
        .onAppear(perform: {
            UITableView.appearance().refreshControl = UIRefreshControl()
            self.quickChallengeViewModel.getUserChallenges()
        })
        .onReceive(self.quickChallengeViewModel.$challengesList, perform: { quickChallenges in
            self.quickChallenges = quickChallenges
        })
        .navigationViewStyle(StackNavigationViewStyle())
        .environment(\.rootPresentationMode, self.$isPresented)
        .environment(\.colorScheme, .dark)
    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView()
    }
}
