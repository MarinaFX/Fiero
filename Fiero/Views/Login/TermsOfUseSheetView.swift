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
        return Tokens.Colors.Neutral.High.pure.value
    }
    var circleColor: Color {
        return Tokens.Colors.Brand.Primary.pure.value
    }
    var smallSpacing: CGFloat {
        Tokens.Spacing.quarck.value
    }
    var spacing: CGFloat {
        return Tokens.Spacing.defaultMargin.value
    }
    
    let navAppearance = UINavigationBarAppearance()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: spacing) {
                    Text("O Fiero é um aplicativo onde você pode criar desafios para interagir com seus amigos. Aqui você encontra nossos termos de uso e políticas de privacidade. Para utilizar o aplicativo é necessário que você leia e esteja de acordo com nossos termos.")
                        .font(textFont)
                        .foregroundColor(textColor)
                    Text("Dados:Nós pedimos alguns dados para você para que as funcionalidade do aplicativo funcionem, mas prezamos a segurança desses dados utilizando servidores na AWS e garantimos que seus dados não serão compartilhados.")
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
                                .accessibilityLabel("")
                            Text("Nome")
                                .font(textFont)
                                .foregroundColor(textColor)
                        }
                        HStack {
                            Circle()
                                .frame(width: circleWeight, height: circleWeight)
                                .foregroundColor(circleColor)
                                .accessibilityLabel("")
                            Text("E-mail")
                                .font(textFont)
                                .foregroundColor(textColor)
                        }
                        HStack {
                            Circle()
                                .frame(width: circleWeight, height: circleWeight)
                                .foregroundColor(circleColor)
                                .accessibilityLabel("")
                            Text("Localização")
                                .font(textFont)
                                .foregroundColor(textColor)
                        }
                    }.padding(.vertical, smallSpacing)
                    Text("Melhorias: Faremos análises do seu padrão de uso no aplicativo para identificar bugs e melhorias de usabilidade, mas todas as informações são anonimizadas pelo sistema automáticamente e não é possível correlacioná-las com você ou qualquer outro usuário do aplicativo. Para saber mais sobre, acesse nossa politica de privacidade na AppStore.")
                        .font(textFont)
                        .foregroundColor(textColor)
                    Text("Restrição de idade: Nossa solução é voltada para o público maior de 3 anos e caso sejam identificados usuários que não cumpram esse requisito os seus dados serão completamente apagados de nossos servidores e o acesso ao aplicativo será bloqueado.")
                        .font(textFont)
                        .foregroundColor(textColor)
                }
                .padding(.all, spacing)
                .navigationTitle("Termos de uso")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Fechar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .accessibilityLabel("Fechar tela de termos de uso")
                }
                ButtonComponent(style: .primary(isEnabled: true), text: "Eu concordo!", action: {
                    termsOfUseAccept = true
                    presentationMode.wrappedValue.dismiss()
                })
                .padding(.all, spacing)
            }
        }
    }
}

struct TermsOfUseSheetView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfUseSheetView(termsOfUseAccept: .constant(false))
    }
}
