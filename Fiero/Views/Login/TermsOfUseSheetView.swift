//
//  TermsOfUseSheetViewIOS15.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 13/07/22.
//

import SwiftUI

struct TermsOfUseSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var termsOfUseAccept: Bool
    
    var textFont: Font {
        return Tokens.FontStyle.callout.font(design: .rounded)
    }
    var circleWeight: CGFloat {
        return 5
    }
    var textColor: Color {
        return Tokens.Colors.Neutral.Low.pure.value
    }
    var circleColor: Color {
        return Tokens.Colors.Brand.Primary.pure.value
    }
    
    let navAppearance = UINavigationBarAppearance()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: Tokens.Spacing.defaultMargin.value) {
                    Text("O Fiero é um aplicativo onde você pode criar desafios para interagir com seus amigos. Aqui você encontra nossos termos de uso e políticas de privacidade. Para utilizar o aplicativo é necessário que você leia e esteja de acordo com nossos termos.")
                        .font(textFont)
                        .foregroundColor(textColor)
                    Text("Dados\nNós pedimos alguns dados para você para que as funcionalidade do aplicativo funcionem, mas prezamos a segurança desses dados utilizando servidores na AWS e garantimos que seus dados não serão compartilhados.")
                        .font(textFont)
                        .foregroundColor(textColor)
                    Text("Os dados que solicitamos são:")
                        .font(textFont)
                        .foregroundColor(textColor)
                    VStack(alignment: .leading) {
                        HStack {
                            Circle()
                                .frame(width: circleWeight, height: circleWeight)
                                .foregroundColor(circleColor)
                            Text("Nome")
                                .font(textFont)
                                .foregroundColor(textColor)
                        }
                        HStack {
                            Circle()
                                .frame(width: circleWeight, height: circleWeight)
                                .foregroundColor(circleColor)
                            Text("E-mail")
                                .font(textFont)
                                .foregroundColor(textColor)
                        }
                        HStack {
                            Circle()
                                .frame(width: circleWeight, height: circleWeight)
                                .foregroundColor(circleColor)
                            Text("Localização")
                                .font(textFont)
                                .foregroundColor(textColor)
                        }
                    }.padding(.vertical, Tokens.Spacing.quarck.value)
                    Text("Nossa solução é voltada para o público maior de 3 anos e caso sejam identificados usuários que não cumpram esse requisito os seus dados serão completamente apagados de nossos servidores e o acesso ao aplicativo será bloqueado.")
                        .font(textFont)
                        .foregroundColor(textColor)
                }
                .padding(.all, Tokens.Spacing.defaultMargin.value)
                .navigationTitle("Termos de uso")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Fechar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ButtonComponent(style: .primary(isEnabled: true), text: "Eu concordo!", action: {
                    termsOfUseAccept = true
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(.all, Tokens.Spacing.defaultMargin.value)
            }
        }
    }
}

struct TermsOfUseSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfUseSheetView(termsOfUseAccept: .constant(false))
    }
}
