//
//  QCNamingView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI
//MARK: QCNamingView
struct QCNamingView: View {
    //MARK: - Variables Setup
    @Environment(\.dismiss) var dismiss
    @Environment(\.sizeCategory) var sizeCategory

    @State private var isNavActiveForAmount: Bool = false
    @State var challengeName: String = ""
    @State var isPresentingAlert: Bool = false
    
    var isOnline: Bool
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCTypeEnum
        
    //MARK: - Body
    var body: some View {
        ZStack{
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            if self.sizeCategory.isAccessibilityCategory {
                ScrollView(showsIndicators: false) {
                    VStack {
                        //MARK: - Header
                        CustomProgressBar(currentPage: .second)
                            .padding()
                        
                        Text("Defina o nome\ndo seu desafio")
                            .multilineTextAlignment(.center)
                            .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .padding(.top, Tokens.Spacing.xxxs.value)
                            .padding(.bottom, Tokens.Spacing.quarck.value)

                        //MARK: Keyboard
                        
                        CreationFlowTextViewComponent(text: self.$challengeName, style: .name) {
                            isNavActiveForAmount.toggle()
                        }
                        .disabled(self.isNavActiveForAmount)
                        .padding(.top, Tokens.Spacing.xs.value)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.5)

                        //MARK: - Bottom Buttons
                        ButtonComponent(style: .secondary(isEnabled: true), text: "Próximo", action: {
                            if challengeName == "" {
                                isPresentingAlert = true
                            } else {
                                isNavActiveForAmount.toggle()
                            }
                        })
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                        
                        Button(action: {
                            self.dismiss()
                        }, label: {
                            Text("Voltar")
                                .bold()
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        })
                        .padding(.vertical, Tokens.Spacing.xxxs.value)

                        NavigationLink("", isActive: $isNavActiveForAmount) {
                            if isOnline {
                                QCAmountWinRulesView(isOnline: isOnline, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName, challengeParticipants: 1)
                            } else {
                                QCSelectParticipantsView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName)
                            }
                        }.hidden()
                    }
                    .alert(isPresented: $isPresentingAlert, content: {
                        Alert(title: Text("Nome vazio"),
                              message: Text("Preencha o nome do seu desafio para continuar"),
                              dismissButton: .cancel(Text("Ok"), action: {
                        }))
                    })
                    .navigationBarHidden(true)
                }
            }
            else {
                VStack {
                    //MARK: - Header
                    CustomProgressBar(currentPage: .second)
                        .padding()
                    
                    Text("Defina o nome\ndo seu desafio")
                        .multilineTextAlignment(.center)
                        .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .padding(.top, Tokens.Spacing.xxxs.value)
                        .padding(.bottom, Tokens.Spacing.quarck.value)

                    //MARK: Keyboard
                    
                    CreationFlowTextViewComponent(text: self.$challengeName, style: .name) {
                        isNavActiveForAmount.toggle()
                    }
                    .disabled(self.isNavActiveForAmount)
                    .padding(.top, Tokens.Spacing.xs.value)
                    
                    //MARK: - Bottom Buttons
                    ButtonComponent(style: .secondary(isEnabled: true), text: "Próximo", action: {
                        if challengeName == "" {
                            isPresentingAlert = true
                        } else {
                            isNavActiveForAmount.toggle()
                        }
                    })
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Text("Voltar")
                            .bold()
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    })
                    .padding(.vertical, Tokens.Spacing.xxxs.value)

                    NavigationLink("", isActive: $isNavActiveForAmount) {
                        if isOnline {
                            QCAmountWinRulesView(isOnline: isOnline, primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName, challengeParticipants: 1)
                        }
                        else {
                            QCSelectParticipantsView(primaryColor: self.primaryColor, secondaryColor: self.secondaryColor, challengeType: self.challengeType, challengeName: self.challengeName)
                        }
                    }.hidden()
                }
                .alert(isPresented: $isPresentingAlert, content: {
                    Alert(title: Text("Nome vazio"),
                          message: Text("Preencha o nome do seu desafio para continuar"),
                          dismissButton: .cancel(Text("Ok"), action: {
                    }))
                })
                .navigationBarHidden(true)
            }
        }
    }
}

struct QuickChallengeNamingView_Previews: PreviewProvider {
    static var previews: some View {
        QCNamingView(isOnline: true, primaryColor: .red, secondaryColor: .white, challengeType: .amount)
    }
}
