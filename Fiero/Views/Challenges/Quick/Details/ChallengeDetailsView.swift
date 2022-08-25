//
//  ChallengeDetailsView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI
import Combine

//MARK: ChallengeDetailsView
struct ChallengeDetailsView: View {
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State private var subscriptions: Set<AnyCancellable> = []

    @State var isPresentingDeletionAlert: Bool = false
    @State var presentDuelOngoingChallenge: Bool = false
    @State var present3or4OngoingChallenge: Bool = false

    @Binding var quickChallenge: QuickChallenge


    //MARK: - Body
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                
                //MARK: - Top Components
                VStack {
                    VStack(spacing: largeSpacing) {
                        VStack (alignment: .center, spacing: nanoSpacing) {
                            HStack(spacing: nanoSpacing) {
                                Text("⚡️")
                                    .font(titleFont)
                                    .foregroundColor(color)
                                
                                Text(quickChallenge.name)
                                    .font(titleFont)
                                    .foregroundColor(color)
                            }
                            
                            Text("Vence quem fizer algo mais vezes \naté bater a pontuação de: ")
                                .multilineTextAlignment(.center)
                                .font(descriptionFont)
                                .foregroundColor(color)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Text("\(quickChallenge.goal)")
                                .font(titleFont)
                                .foregroundColor(color)
                        }
                        
                        //MARK: - Mid Components
                        VStack(spacing: extraExtraExtraSmallSpacing) {
                            Text("Participantes")
                                .font(titleFont)
                                .foregroundColor(color)
                            
                            GroupComponent(scoreboard: false, style: [.participantDefault(isSmall: false)], quickChallenge: $quickChallenge)
                        }
                    }
                    
                    Spacer()
                    
                    //MARK: - Bottom Components
                    VStack(spacing: quarkSpacing) {
                        if self.quickChallenge.maxTeams == 2 {
                            NavigationLink("", isActive: self.$presentDuelOngoingChallenge) {
                                DuelScreenView(quickChallenge: $quickChallenge)
                            }
                            .hidden()
                        }
                        else {
                            NavigationLink("", isActive: self.$present3or4OngoingChallenge) {
                                Ongoing3Or4WithPauseScreenView(quickChallenge: self.$quickChallenge, didTapPauseButton: false)
                            }
                            .hidden()
                        }
                        
                        ButtonComponent(style: .secondary(isEnabled: true),
                                        text: "Começar desafio!") {
                            self.quickChallengeViewModel.beginChallenge(challengeId: self.quickChallenge.id, alreadyBegin: true)
                            
                            if self.quickChallenge.maxTeams == 2 {
                                self.presentDuelOngoingChallenge.toggle()
                            }
                            else {
                                self.present3or4OngoingChallenge.toggle()
                            }
                        }
                        
                        ButtonComponent(style: .black(isEnabled: true),
                                        text: "Deletar desafio") {
                            self.isPresentingDeletionAlert.toggle()
                        }
                    }
                    .padding(.bottom, largeSpacing)
                }
                .padding(.horizontal)
                .alert(isPresented: self.$isPresentingDeletionAlert, content: {
                    //TODO: Fix alert content
                    Alert(title: Text("Deletar desafio"), message: Text("Essa ação não poderá ser desfeita"), primaryButton: .cancel(Text("Cancelar"), action: {
                        self.isPresentingDeletionAlert = false
                    }), secondaryButton: .destructive(Text("Apagar desafio"), action: {
                        self.quickChallengeViewModel.deleteChallenge(by: quickChallenge.id)
                            .sink { completion in
                                switch completion {
                                    case .finished:
                                        self.presentationMode.wrappedValue.dismiss()
                                    case .failure(let error):
                                        print(error)
                                        // TODO: show alert
                                }
                            } receiveValue: { _ in }
                            .store(in: &subscriptions)
                    }))
                })
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading, content: {
                        Button("Voltar", action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                    })
                }
                
            }
            .accentColor(Color.white)
        }

    }
    
    //MARK: - DS Tokens
    var color: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var quarkSpacing: CGFloat {
        return Tokens.Spacing.quarck.value
    }
    var nanoSpacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    var extraExtraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var largeSpacing: CGFloat {
        return Tokens.Spacing.lg.value
    }
    var titleFont: Font {
        return Tokens.FontStyle.title2.font(weigth: .bold)
    }
    var descriptionFont: Font {
        return Tokens.FontStyle.caption.font()
    }
}
 
//MARK: - Previews
struct ChallengeDetailsScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailsView(quickChallenge: .constant(QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [Team(id: "id", name: "Naty", quickChallengeId: "id", createdAt: "", updatedAt: ""), Team(id: "id2", name: "player2", quickChallengeId: "id", createdAt: "", updatedAt: "")], owner: User(email: "a@naty.pq", name: "naty"))))
            .environmentObject(QuickChallengeViewModel())
    }
}

