//
//  QCChallengeCreatedView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI
//MARK: QCChallengeCreatedView
struct QCChallengeCreatedView: View {
    //MARK: - Variables Setup
    @Environment(\.rootPresentationMode) private var rootPresentationMode
    
    @ObservedObject var quickChallengeViewModel: QuickChallengeViewModel
    @State var didPushToHomeScreen: Bool = false
    @State var didPushToStartChallenge: Bool = false
    @State var isPresentingAlert: Bool = false
    @Binding var serverResponse: ServerResponse
    
    var challengeType: QCType
    var challengeName: String
    var challengeParticipants: Int
    var goal: Int
    var goalMeasure: String {
        switch challengeType {
            case .amount:
                return "unity"
            case .byTime(let measure):
                return measure
            case .bestOf:
                return "rounds"
        }
    }
    
    var title: String {
        if serverResponse.statusCode != 201 {
            return "Não conseguimos \ncriar seu desafio"
        }
        
        return "Desafio criado com sucesso"
    }

    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            Image("Olhos")
                .padding(.top, Tokens.Spacing.sm.value * 1.5)
            
            Text(self.title)
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top, Tokens.Spacing.sm.value)
            
            Spacer()
            
            //MARK: - Bottom Buttons
            if self.serverResponse.statusCode != 201 {
                ButtonComponent(style: .secondary(isEnabled: true), text: "Tentar novamente", action: {
                    self.quickChallengeViewModel.createQuickChallenge(name: self.challengeName, challengeType: self.challengeType, goal: self.goal, goalMeasure: self.goalMeasure, numberOfTeams: 0, maxTeams: 0)
                })
                .padding(.bottom, Tokens.Spacing.xxxs.value)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
                
                Button(action: {
                    self.rootPresentationMode.wrappedValue.popToRootViewController()
                }, label: {
                    Text("Voltar para o início")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.bottom, Tokens.Spacing.xxxl.value)
            }
            else {
                Button(action: {
                    self.rootPresentationMode.wrappedValue.popToRootViewController()
                }, label: {
                    Text("Ir para lista de desafios")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.bottom, Tokens.Spacing.xxxs.value)
                
                ButtonComponent(style: .secondary(isEnabled: true), text: "Começar desafio!", action: {
                    
                })
                .padding(.bottom, Tokens.Spacing.xxxl.value)
                .padding(.horizontal, Tokens.Spacing.xxxs.value)
            }
        }
        .alert(isPresented: self.$isPresentingAlert, content: {
            Alert(title: Text("Erro"),
                  message: Text(self.serverResponse.description),
                  dismissButton: .cancel(Text("OK"), action: { self.isPresentingAlert = false })
            )
        })
        .onChange(of: self.quickChallengeViewModel.serverResponse, perform: { serverResponse in
            self.serverResponse = serverResponse
            
            if self.serverResponse.statusCode != 201 {
                self.isPresentingAlert.toggle()
            }
        })
        .makeDarkModeFullScreen(color: Color(red: 0.345, green: 0.322, blue: 0.855, opacity: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct QuickChallengeCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        QCChallengeCreatedView(quickChallengeViewModel: QuickChallengeViewModel(), serverResponse: .constant(.badRequest), challengeType: .amount, challengeName: "", challengeParticipants: 0, goal: 0)
            //.previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
    }
}
