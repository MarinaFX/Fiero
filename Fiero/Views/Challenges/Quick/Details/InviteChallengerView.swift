//
//  InviteChallengerView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/10/22.
//

import SwiftUI

struct InviteChallengerView: View {
    @State var inviteCode: String
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text(LocalizedStringKey("inviteTitle"))
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, Tokens.Spacing.xxxs.value)
                    
                    Text(LocalizedStringKey("inviteDescription"))
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, Tokens.Spacing.xs.value)
                    
                    Text(inviteCode)
                        .font(Font.system(size: 60))
                        .bold()
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .padding(.bottom, Tokens.Spacing.xxs.value)
                    
                    Button {
                        print("código copiado")
                    } label: {
                        Text(LocalizedStringKey("inviteButtonCodeText"))
                            .font(Tokens.FontStyle.caption.font())
                            .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                            .padding(Tokens.Spacing.nano.value)
                            .background(Tokens.Colors.Neutral.High.pure.value)
                            .cornerRadius(Tokens.Border.BorderRadius.normal.value)
                    }
                    
                    Spacer()
                    
                    ButtonComponent(style: .black(isEnabled: true), text: "inviteButtonBackToDetails") {
                        //TODO: dismiss to details
                        print("voltar para detalhes")
                    }
                    .padding(.bottom, Tokens.Spacing.md.value)
                }
                .padding(.horizontal, Tokens.Spacing.xl.value)
            }
            .navigationTitle(LocalizedStringKey("inviteNavTitle"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct InviteChallengerView_Previews: PreviewProvider {
    static var previews: some View {
        InviteChallengerView(inviteCode: "HD1G5")
    }
}
