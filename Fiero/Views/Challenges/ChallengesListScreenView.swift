//
//  ChallengesListScreenView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/07/22.
//

import SwiftUI
import Combine

//MARK: - HomeView
struct HomeView: View {
    //MARK: Variables Setup
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var isPresentingQuickChallengeCreation: Bool = false
    @State var isPresentingChallengeDetails: Bool = false
    @State var isPresented: Bool = false
    @State var focusedChallenge: QuickChallenge?
    @State var isShowingDeleteAlert: Bool = false
    @State var isShowingDeleteErrorAlert: Bool = false

    @State var subscriptions: Set<AnyCancellable> = []
    
    private var quickChallenges: Binding<[QuickChallenge]> {
        Binding(get: {
            return self.quickChallengeViewModel.sortedList
        }, set: {
            self.quickChallengeViewModel.challengesList = $0
        })
    }
    
    private var isShowingAlert: Binding<Bool> {
        Binding(get: {
            self.quickChallengeViewModel.showingAlert ||
            self.isShowingDeleteAlert ||
            self.isShowingDeleteErrorAlert
        }, set: { _ in
            if self.quickChallengeViewModel.showingAlert {
                self.quickChallengeViewModel.showingAlert = false
            } else if isShowingDeleteAlert {
                self.isShowingDeleteAlert = false
            } else {
                self.isShowingDeleteErrorAlert = false
            }
        })
    }
    
    //MARK: Body
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                
                VStack {
                    if self.quickChallenges.count > 0 {
                        ChallengesListScreenView(
                            quickChallenges: self.quickChallenges,
                            focusedChallenge: self.$focusedChallenge,
                            isShowingDeleteAlert: self.$isShowingDeleteAlert)
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
                            HapticsController.shared.activateHaptics(hapticsfeedback: .heavy)
                        }, label: {
                            Image(systemName: "plus")
                                .foregroundColor(Tokens.Colors.Highlight.one.value)
                                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .rounded))
                                .padding(.trailing, Tokens.Spacing.nano.value)
                        })
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .onAppear(perform: {
                    UITableView.appearance().refreshControl = UIRefreshControl()
                    self.quickChallengeViewModel.getUserChallenges()    
                })
                .alert(isPresented: self.isShowingAlert, content: {
                    if isShowingDeleteAlert {
                        return Alert(title: Text(DetailsAlertCases.deleteChallenge.title),
                                     message: Text(DetailsAlertCases.deleteChallenge.message),
                                     primaryButton: .cancel(Text(DetailsAlertCases.deleteChallenge.primaryButtonText), action: {
                            self.isShowingDeleteAlert = false
                        }), secondaryButton: .destructive(Text("Apagar desafio"), action: {
                            guard let challenge = focusedChallenge else {
                                return
                            }
                            
                            self.quickChallengeViewModel.deleteChallenge(by: challenge.id)
                                .sink(receiveCompletion: { completion in
                                    switch completion {
                                        case .finished:
                                            print("delete successfully")
                                        case .failure(_):
                                            self.isShowingDeleteErrorAlert = true
                                    }
                                }, receiveValue: { _ in })
                                .store(in: &subscriptions)
                        }))
                    } else if self.quickChallengeViewModel.showingAlert {
                        return Alert(
                            title: Text("Oops, muito desafiador!"),
                            message: Text("Não conseguimos buscar seus desafios agora, tente novamente"),
                            dismissButton: .default(Text("OK")){
                                self.quickChallengeViewModel.showingAlertToFalse()
                            }
                        )
                    } else if self.isShowingDeleteErrorAlert {
                        return Alert(title: Text(DetailsAlertCases.failureDeletingChallenge.title),
                                     message: Text(DetailsAlertCases.failureDeletingChallenge.message),
                                     dismissButton: .cancel(Text(DetailsAlertCases.failureDeletingChallenge.primaryButtonText), action: {
                            self.isShowingDeleteErrorAlert = false
                        }))
                    } else {
                        return Alert(title: Text("not expected"))
                    }
                })
            }
            .navigationBarHidden(false)
            .navigationTitle("Meus desafios")
        }
        .environment(\.colorScheme, .dark)
    }
}

//MARK: - ChallengesListScreenView
struct ChallengesListScreenView: View {
    //MARK: Variables Setup
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var isShowingErrorAlert: Bool = false
    @State var isShowingEnterWithCodeView: Bool = false
    
    @Binding var quickChallenges: [QuickChallenge]
    @Binding var focusedChallenge: QuickChallenge?
    
    @Binding var isShowingDeleteAlert: Bool
    
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
    
    //MARK: body
    var body: some View {
        ZStack {
            List(self.quickChallenges, id: \.self) { challenge in
                ZStack {
                    ChallengeListCell(quickChallenge: .constant(challenge))
                }
                .onTapGesture {
                    self.focusedChallenge = challenge
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                    Button(role: .destructive, action: {
                        self.focusedChallenge = challenge
                        self.isShowingDeleteAlert.toggle()
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                })
                
            }
            .fullScreenCover(item: $focusedChallenge) { item in
                if item.online {
                    OnlineChallengeDetailsView(quickChallenge: getBindingWith(id: item.id))
                        .environmentObject(self.quickChallengeViewModel)
                }
                else {
                    ChallengeDetailsView(quickChallenge: getBindingWith(id: item.id))
                        .environmentObject(self.quickChallengeViewModel)
                }
            }
            .refreshable {
                self.quickChallengeViewModel.getUserChallenges()
            }
            .listStyle(.plain)
            VStack{
                Spacer()
                ButtonComponent(style: .primary(isEnabled: true), text: "Entrar por código") {
                    self.isShowingEnterWithCodeView = true
                }
                .sheet(isPresented: self.$isShowingEnterWithCodeView, content: {
                    EnterWithCodeView()
                })
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                .padding(.bottom, Tokens.Spacing.defaultMargin.value)
            }
        }
    }
}

struct ChallengesListScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengesListScreenView(quickChallenges: .constant([QuickChallenge(id: "", name: "flemis", invitationCode: "", type: "amount", goal: 115, goalMeasure: "unity", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 2, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))]), focusedChallenge: .constant(QuickChallenge(id: "", name: "flemis", invitationCode: "", type: "amount", goal: 115, goalMeasure: "unity", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 2, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))), isShowingDeleteAlert: .constant(false))
            .environmentObject(QuickChallengeViewModel())
    }
}
