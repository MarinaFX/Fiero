//
//  ChallengesListScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/07/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var isPresentingQuickChallengeCreation: Bool = false
    @State var isPresentingChallengeDetails: Bool = false
    @State var isPresented: Bool = false
    @State var presentModalIndex: QuickChallenge? = nil

    private var quickChallenges: [QuickChallenge] {
        self.quickChallengeViewModel.challengesList
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                
                VStack {
                    if self.quickChallenges.count > 0 {
                        ChallengesListScreenView(quickChallenges: self.quickChallenges.sorted(by: { $0.updatedAt > $1.updatedAt }))
                    }
                    else {
                        EmptyChallengesView()
                    }
                }
                .fullScreenCover(isPresented: $isPresentingQuickChallengeCreation) {
                    QCCategorySelectionView()
                }
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isPresentingQuickChallengeCreation = true
                        }, label: {
                            Image(systemName: "plus")
                                .font(Tokens.FontStyle.title2.font(weigth: .bold))
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        })
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear(perform: {
                    UITableView.appearance().refreshControl = UIRefreshControl()
                    self.quickChallengeViewModel.getUserChallenges()
                })
            }
            .navigationBarHidden(false)
            .navigationTitle("Seus desafios")
        }
        .environment(\.colorScheme, .dark)

    }
}

struct ChallengesListScreenView: View {
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var presentModalIndex: QuickChallenge? = nil
    
    var quickChallenges: [QuickChallenge]
    
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                ListWithoutSeparator(self.quickChallenges, id: \.self) { challenge in
                    ZStack {
                        CustomTitleImageListRow(title: challenge.name)
                    }
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        self.presentModalIndex = challenge
                    }
                }
                .sheet(item: $presentModalIndex) { item in
                    ChallengeDetailsView(quickChallenge: item)
                        .environmentObject(self.quickChallengeViewModel)
                }
                .refreshable {
                    self.quickChallengeViewModel.getUserChallenges()
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .listStyle(.plain)
            } else {
                //TODO: Refreshable list for iOS 14
                ListWithoutSeparator(self.quickChallenges, id: \.self) { challenge in
                    NavigationLink(destination: ChallengeDetailsView(quickChallenge: challenge), label: {
                        CustomTitleImageListRow(title: challenge.name)
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .listStyle(.plain)
            }
        }
    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView(quickChallenges: [])
    }
}
