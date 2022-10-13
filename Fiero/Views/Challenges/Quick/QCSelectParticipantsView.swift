//
//  QCSelectParticipantsView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI

struct QCSelectParticipantsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var challengeParticipants: Int = 2
    @State var tabViewSelection: Int = 2
    @State var pushNextView: Bool = false
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCTypeEnum
    var challengeName: String

    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            VStack {
                CustomProgressBar(currentPage: .second, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor)
                    .padding()
                
                Text("Escolha a quantidade\nde participantes")
                    .multilineTextAlignment(.center)
                    .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .padding(.top, Tokens.Spacing.xxxs.value)

                Spacer()
                
                TabView(selection: self.$tabViewSelection) {
                    ChallengeParticipantsSelectionCardView(amount: "2")
                        .padding(Tokens.Spacing.sm.value)
                        .tag(2)
                    
                    ChallengeParticipantsSelectionCardView(amount: "3")
                        .padding(Tokens.Spacing.sm.value)
                        .tag(3)
                    
                    ChallengeParticipantsSelectionCardView(amount: "4")
                        .padding(Tokens.Spacing.sm.value)
                        .tag(4)
                    
                }
                .tabViewStyle(PageTabViewStyle())
                
                switch tabViewSelection {
                    case 2:
                        ButtonComponent(style: .secondary(isEnabled: true), text: "numberOfChallengers \(tabViewSelection)", action: {
                            self.pushNextView.toggle()
                        })
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    case 3:
                        ButtonComponent(style: .secondary(isEnabled: true), text: "numberOfChallengers \(tabViewSelection)", action: {
                            self.pushNextView.toggle()
                        })
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    case 4:
                        ButtonComponent(style: .secondary(isEnabled: true), text: "numberOfChallengers \(tabViewSelection)", action: {
                            self.pushNextView.toggle()
                        })
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    default:
                        ButtonComponent(style: .secondary(isEnabled: true), text: "numberOfChallengers \(tabViewSelection)", action: {
                            self.pushNextView.toggle()
                        })
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                }
                
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Voltar")
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                })
                .padding(.vertical, Tokens.Spacing.xxxs.value)
                
                NavigationLink("", isActive: self.$pushNextView, destination: {
                    QCAmountWinRulesView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName, challengeParticipants: self.challengeParticipants)
                })
            }
            .onChange(of: self.tabViewSelection, perform: { tabViewSelection in
                self.challengeParticipants = tabViewSelection
            })
        }.navigationBarHidden(true)
    }
}

struct ChallengeParticipantsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        QCSelectParticipantsView(primaryColor: .red, secondaryColor: .red, challengeType: .amount, challengeName: "")
    }
}
