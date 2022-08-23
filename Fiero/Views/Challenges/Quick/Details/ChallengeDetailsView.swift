//
//  ChallengeDetailsView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 20/07/22.
//

import SwiftUI
//MARK: ChallengeDetailsView
struct ChallengeDetailsView: View {
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var quickChallengeViewModel: QuickChallengeViewModel
    @State var presentDuelOngoingChallenge: Bool = false
    @State var present3or4OngoingChallenge: Bool = false
    @State var quickChallenge: QuickChallenge
    @State var isPresentingDeletionAlert: Bool = false

    //MARK: - Body
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
            //MARK: - Back Button
            VStack (alignment: .trailing) {
                HStack {
                    Spacer()
                    HStack {
//                        Image(systemName: "chevron.left")
//                            .font(.title2)
//                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        Text("Voltar").foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    }.onTapGesture {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                Spacer()
            }.padding(Tokens.Spacing.defaultMargin.value)
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
                        .padding(.top, largeSpacing)
                        
                        Text("Vence quem fizer algo mais vezes \naté bater a pontuação de: ")
                            .multilineTextAlignment(.center)
                            .font(descriptionFont)
                            .foregroundColor(color)
                        
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
                .padding()
                
                Spacer()
                
                //MARK: - Bottom Components
                VStack(spacing: quarkSpacing) {
                    NavigationLink("", isActive: self.$presentDuelOngoingChallenge) {
                        DuelScreenView()
                    }
                    .hidden()
                    
                    NavigationLink("", isActive: self.$present3or4OngoingChallenge) {
                        Ongoing3_4ScreenView(quickChallenge: self.quickChallenge)
                    }
                    .hidden()
                    
                    ButtonComponent(style: .secondary(isEnabled: true),
                                    text: "Começar desafio!") {
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
            .padding()
            .alert(isPresented: self.$isPresentingDeletionAlert, content: {
                //TODO: Fix alert content
                Alert(title: Text("Deletar desafio"), message: Text("Essa ação não poderá ser desfeita"), primaryButton: .cancel(Text("Cancelar"), action: {
                    self.isPresentingDeletionAlert = false
                }), secondaryButton: .destructive(Text("Apagar desafio"), action: {
                    self.quickChallengeViewModel.deleteChallenge(by: quickChallenge.id)
                    
                    if !self.quickChallengeViewModel.challengesList.contains(where: { $0.id == self.quickChallenge.id }) {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }))
            })
        }
        .accentColor(Color.white)
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
        ChallengeDetailsView(quickChallengeViewModel: QuickChallengeViewModel(), quickChallenge: QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [Team(id: "id", name: "Naty", quickChallengeId: "id", createdAt: "", updatedAt: ""), Team(id: "id2", name: "player2", quickChallengeId: "id", createdAt: "", updatedAt: "")], owner: User(email: "a@naty.pq", name: "naty")))
    }
}
