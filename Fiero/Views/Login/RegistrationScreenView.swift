//
//  RegistrationScreen.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/07/22.
//

import SwiftUI

//MARK: RegistrationScreenView
struct RegistrationScreenView: View {
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode

    @StateObject var userRegistrationViewModel = UserRegistrationViewModel()
    @State var serverResponse: ServerResponse
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State var moving = false
    
    //MARK: - body
    var body: some View {
        NavigationView {
            ZStack {
                Image("LoginBackground")
                    .scaledToFill()
                
                GlassPhormism {
                    VStack(spacing: Tokens.Spacing.xxxs.value){
                        VStack(spacing: Tokens.Spacing.xxs.value){
                            Text("Boas vindas, desafiante")
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                                .font(Tokens.FontStyle.title3.font(weigth: .bold,
                                                                   design: .rounded))
                            //MARK: TextFilds elements
                            VStack(spacing: Tokens.Spacing.xxxs.value){
                                CustomTextFieldView(type: .none, style: .primary, placeholder: "Nome", helperText: "", isWrong: .constant(false), text: $username)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                    
                                CustomTextFieldView(type: .none, style: .primary, placeholder: "E-mail", helperText: "", isWrong: .constant(false), text: $email)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                    
                                CustomTextFieldView(type: .both, style: .primary, placeholder: "Senha", helperText: "", isWrong: .constant(false), text: $password)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                            }
                            //MARK: Button and CheckBox
                            CheckboxComponent(style: .dark, text: "Concordo com os", linkedText: "termos de uso", tapHandler: { isChecked in
                                print(isChecked)
                            }, action: {
                                print("clicked")
                            })
                            
                            ButtonComponent(style: .secondary(isEnabled: true),
                                            text: "Criar conta!",
                                            action: {
                                if !self.username.isEmpty && !self.email.isEmpty && !self.password.isEmpty {
                                    self.userRegistrationViewModel.createUserOnDatabase(for: User(email: self.email, name: self.username, password: self.password))
                                    }
                                })
                        }
                        //MARK: Last elements
                        HStack{
                            Text("Já tem uma conta?")
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                                .font(Tokens.FontStyle.callout.font())
                            Button("Faça Login!") {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .font(Tokens.FontStyle.callout.font(weigth: .bold))
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .onChange(of: self.serverResponse, perform: { serverResponse in
                self.serverResponse = serverResponse
            })
        }
    }
}

//MARK: -
//MARK: - GlassPhormism
struct GlassPhormism<Content>: View where Content: View {
    //MARK: - Variables Setup
    
    @ViewBuilder var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    //MARK: - body
    var body: some View {
        
        if #available(iOS 15.0, *) {
            content
                .frame(width: UIScreen.main.bounds.width * 0.9,
                       height: UIScreen.main.bounds.height * 0.53, alignment: .center)
                .padding(.vertical, Tokens.Spacing.xxs.value)
                .background(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 0.5)
                )
        }
        else {
            ZStack {
                Image("LoginBackground")
                    .frame(width: UIScreen.main.bounds.width * 0.9,
                           height: UIScreen.main.bounds.height * 0.53,
                           alignment: .center)
                    .blur(radius: 10)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                        .stroke(.white, lineWidth: 0.5)
                    )
                    .overlay(
                        content
                            .padding(.vertical, Tokens.Spacing.xxs.value)
                    )
            }
        }
    }
}
