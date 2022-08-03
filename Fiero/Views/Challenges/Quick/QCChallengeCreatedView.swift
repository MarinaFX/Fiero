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
    
    @State var didPushToHomeScreen: Bool = false
    @State var didPushToStartChallenge: Bool = false
    
    var challenge: QuickChallenge?

    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            Image("Olhos")
                .padding(.top, Tokens.Spacing.sm.value * 1.5)
            
            Text("Desafio criado com sucesso")
                .multilineTextAlignment(.center)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top, Tokens.Spacing.sm.value)
            
            Spacer()
            
            //MARK: - Bottom Buttons
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
        .padding(.top, Tokens.Spacing.lg.value)
        .padding(.bottom, Tokens.Spacing.xxs.value)
        .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .top
            )
        .background(Color(red: 0.345, green: 0.322, blue: 0.855, opacity: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct QuickChallengeCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        QCChallengeCreatedView()
            //.previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
    }
}
