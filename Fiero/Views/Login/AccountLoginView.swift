//
//  AccountLoginView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 07/07/22.
//

import SwiftUI

//MARK: - Account Login View
struct AccountLoginView: View {
    //MARK: Variables Setup
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var userLoginViewModel: UserLoginViewModel = UserLoginViewModel()
    
    @State private(set) var user: User = .init(email: "", name: "", password: "")
    @State private var isFieldIncorrect = false
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var isRegistrationSheetShowing: Bool = false
    
    private let namePlaceholder: String = "Name"
    private let emailPlaceholder: String = "E-mail"
    private let passwordPlaceholder: String = "Senha"
    
    //MARK: body View
    var body: some View {
        ZStack {
            Image("LoginBackground")
                .scaledToFill()
            
            //MARK: Blurred View
            BlurredSquaredView(usernameText: self.$emailText) {
                VStack {
                    Text("Boas vindas, desafiante")
                        .font(.system(size: Tokens.Fonts.Size.sm.value, weight: Tokens.Fonts.Weight.bold.value, design: Tokens.Fonts.Familiy.base.value))
                        .foregroundColor(.white)
                                        
                    CustomTextFieldView(type: .none, style: .primary, placeholder: emailPlaceholder, isSecure: false, isWrong: .constant(false), text: self.$emailText)
                        .padding(Tokens.Spacing.nano.value)
                    
                    CustomTextFieldView(type: .icon, style: .primary, placeholder: passwordPlaceholder, isSecure: true, isWrong: .constant(false), text: self.$passwordText)
                        .padding(Tokens.Spacing.nano.value)
                    
                    Button(action: {
                        //
                    }, label: {
                        Text("Esqueceu sua senha?")
                            .font(.system(size: Tokens.Fonts.Size.xxs.value, weight: Tokens.Fonts.Weight.regular.value, design: Tokens.Fonts.Familiy.support.value))
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .underline(true, color: Tokens.Colors.Neutral.High.pure.value)
                    })
                    .padding(.vertical, Tokens.Spacing.xxxs.value)
                    
                    ButtonComponent(style: .secondary(isEnabled: true), text: "Fazer login!", action: {
                        self.userLoginViewModel.authenticateUser(email: self.emailText, password: self.passwordText)
                    })
                    
                    HStack {
                        Text("Ainda não tem uma conta?")
                            .font(.system(size: Tokens.Fonts.Size.xs.value, weight: Tokens.Fonts.Weight.regular.value, design: Tokens.Fonts.Familiy.support.value))
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        
                        Button(action: {
                            self.isRegistrationSheetShowing.toggle()
                        }, label: {
                            Text("Cadastre-se!")
                                .font(.system(size: Tokens.Fonts.Size.xs.value, weight: Tokens.Fonts.Weight.bold.value, design: Tokens.Fonts.Familiy.support.value))
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        })
                        .sheet(isPresented: self.$isRegistrationSheetShowing, content: {
                            RegistrationScreenView()
                        })
                    }
                    .padding(.top, Tokens.Spacing.xxxs.value)
                }
                .padding(Tokens.Spacing.xxxs.value)
            }
        }
        .ignoresSafeArea()
        .onChange(of: self.userLoginViewModel.user, perform: { user in
            self.user = user
        })
    }
}

//MARK: - Blurred Squared View
struct BlurredSquaredView<Content>: View where Content: View {
    
    //MARK: Variables Setup
    @ViewBuilder var content: Content
    @Binding private(set) var usernameText: String
        
    init(usernameText: Binding<String>, @ViewBuilder content: @escaping () -> Content) {
        self._usernameText = usernameText
        self.content = content()
    }
    
    //MARK: body View
    var body: some View {
            if #available(iOS 15.0, *) {
                content
                    .frame(width: UIScreen.main.bounds.width * 0.9,
                           height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                    .padding(.vertical, Tokens.Spacing.xxs.value)
                    //.padding(.horizontal, Tokens.Spacing.xxxs.value)
                    .background(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 0.5)
                    )
            } else {
                ZStack {
                    Image("LoginBackground")
                        .frame(width: UIScreen.main.bounds.width * 0.9,
                               height: UIScreen.main.bounds.height * 0.5, alignment: .center)
                        .blur(radius: 10)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 0.5)
                        )
                        .overlay(
                            content
                                .padding(.vertical, Tokens.Spacing.xs.value)
                        )
                }
            }
    }
}

struct AccountLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AccountLoginView()
    }
}
