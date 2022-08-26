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

    private var quickChallenges: Binding<[QuickChallenge]> {
        Binding(get: {
            return self.quickChallengeViewModel.sortedList
        }, set: {
            self.quickChallengeViewModel.challengesList = $0
        })
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                
                VStack {
                    if self.quickChallenges.count > 0 {
                        ChallengesListScreenView(quickChallenges: self.quickChallenges)
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
    
    @Binding var quickChallenges: [QuickChallenge]
    
    func getBindingWith(id: String) -> Binding<QuickChallenge> {
        guard let index = self.quickChallenges.firstIndex(where: { $0.id == id }) else {
            return .constant(QuickChallenge(id: "teste", name: "Truco", invitationCode: "teste", type: "Quantidade", goal: 3, goalMeasure: "unity", finished: false, ownerId: "teste", online: false, alreadyBegin: true, maxTeams: 4, createdAt: "teste", updatedAt: "teste", teams: [], owner: User(email: "teste", name: "teste")))
        }
        
        let binding = Binding<QuickChallenge>.init(get: {
            return self.quickChallenges[index]
        }, set: {
            self.quickChallenges[index] = $0
        })
        
        
        if #available(iOS 15, *) {
            return self.$quickChallenges.first(where: { $0.wrappedValue.id == id }) ?? binding
        }
        else {
            return binding
        }
    }
    
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
                    ChallengeDetailsView(quickChallenge: getBindingWith(id: item.id))
                        .environmentObject(self.quickChallengeViewModel)
                }
                .refreshable {
                    self.quickChallengeViewModel.getUserChallenges()
                }
                .listStyle(.plain)
            } else {
                //TODO: Refreshable list for iOS 14
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
                    ChallengeDetailsView(quickChallenge: getBindingWith(id: item.id))
                        .environmentObject(self.quickChallengeViewModel)
                }
                .listStyle(.plain)
            }
        }
    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView(quickChallenges: .constant([]))
    }
}
