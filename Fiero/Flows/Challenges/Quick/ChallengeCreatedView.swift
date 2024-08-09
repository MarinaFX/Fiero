//
//  ChallengeCreatedView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 19/07/22.
//

import SwiftUI
import Combine

struct ChallengeCreatedView: View {
    //MARK: - Variables Setup
    
    @State var isPresentingChallenge: Bool = false
    @State var isPresentingAlert: Bool = false
    @State var subscriptions: Set<AnyCancellable> = []
    
    @State private var ended: Bool = false

    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            
            LottieView(fileName: "success-loop", reverse: false, loop: true, ended: $ended).frame(width: 350 , height: 200)
            
            Text("Desafio criado com sucesso")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .padding(.top, Tokens.Spacing.sm.value)
                .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
            
            Spacer()
            
            Button(action: {
                RootViewController.popToRootViewController()
            }, label: {
                Text(LocalizedStringKey("Ir para a tela de criação"))
                    .bold()
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
            })
            .padding(.bottom, Tokens.Spacing.xxxs.value)
        }
        .makeDarkModeFullScreen(color: Color(red: 0.345, green: 0.322, blue: 0.855, opacity: 1))
        .ignoresSafeArea()
        .navigationBarHidden(true)
    }
}

struct QuickChallengeCreatedView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCreatedView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
    }
}
