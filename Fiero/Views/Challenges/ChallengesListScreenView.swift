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
                            Haptics.shared.play(.heavy)
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
                .alert(isPresented: $quickChallengeViewModel.showingAlert) {
                    Alert(
                        title: Text("Oops, muito desafiador!"),
                        message: Text("Não conseguimos buscar seus desafios agora, tente novamente"),
                        dismissButton: .default(Text("OK")){
                            self.quickChallengeViewModel.showingAlertToFalse()
                        }
                    )
                }
            }
            .navigationBarHidden(false)
            .navigationTitle("Meus desafios")
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
        
        return self.$quickChallenges.first(where: { $0.wrappedValue.id == id }) ?? binding
    }
    
    var body: some View {
        VStack {
            List(self.quickChallenges, id: \.self) { challenge in
                ZStack {
                    ChallengeListCell(quickChallenge: challenge)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                    Button(role: .destructive, action: {
                        
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                })
                .onTapGesture {
                    self.presentModalIndex = challenge
                }
            }
            .fullScreenCover(item: $presentModalIndex) { item in
                ChallengeDetailsView(quickChallenge: getBindingWith(id: item.id))
                    .environmentObject(self.quickChallengeViewModel)
            }
            .refreshable {
                self.quickChallengeViewModel.getUserChallenges()
            }
            .listStyle(.plain)
        }
    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView(quickChallenges: .constant([QuickChallenge(id: "", name: "flemis", invitationCode: "", type: "amount", goal: 115, goalMeasure: "unity", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 2, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))]))
    }
}
