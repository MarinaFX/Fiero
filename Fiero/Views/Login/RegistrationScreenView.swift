//
//  RegistrationScreen.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/07/22.
//

import SwiftUI

struct RegistrationScreenView: View {
    
    @StateObject var userRegistrationViewModel = UserRegistrationViewModel()
    @State var moving = false
    
    var body: some View {
        ZStack {
            Image("LoginBackground")
                .scaledToFill()
            GlassPhormism(userRegistrationViewModel: self.userRegistrationViewModel)
//                .offset(x: 0, y: 50)
        }
        .ignoresSafeArea()
    }
}
struct GlassPhormism: View {
    
    @ObservedObject var userRegistrationViewModel: UserRegistrationViewModel
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack {
            Image("LoginBackground")
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.53, alignment: .center)
//                .offset(x: 0, y: -50)
                .blur(radius: 10)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay( RoundedRectangle(cornerRadius: 16)
                    .stroke(.white, lineWidth: 0.5))
                .overlay(
                    VStack(spacing: Tokens.Spacing.xxxs.value){
                        VStack(spacing: Tokens.Spacing.xxs.value){
                            Text("Boas vindas, desafiante")
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                                .font(.system(size: Tokens.Fonts.Size.sm.value, weight: Tokens.Fonts.Weight.bold.value, design: Tokens.Fonts.Familiy.base.value))
                            //TextFilds elements
                            VStack(spacing: Tokens.Spacing.xxxs.value){
                                CustomTextFieldView(type: .none, style: .primary, placeholder: "Nome", helperText: "", isWrong: .constant(false), text: $username)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                    
                                CustomTextFieldView(type: .none, style: .primary, placeholder: "E-mail", helperText: "", isWrong: .constant(false), text: $email)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                    
                                CustomTextFieldView(type: .both, style: .primary, placeholder: "Senha", helperText: "", isWrong: .constant(false), text: $password)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                            }
                            //Button and CheckBox
                            CheckboxComponent(style: .dark, text: "Concordo com os termos de uso", tapHandler: { isChecked in
                                print(isChecked)
                            })
                            
                            ButtonComponent(style: .secondary(isEnabled: true),
                                            text: "Criar conta!",
                                            action: {
                                if !self.username.isEmpty && !self.email.isEmpty && !self.password.isEmpty {
                                    self.userRegistrationViewModel.createUserOnDatabase(for: User(email: self.email, name: self.username, password: self.password)) { response in
                                        if response == .userCreated {
                                            
                                        }
                                        else {
                                            //present error while creating account alert
                                        }
                                    }
                                }
                            })
                        }
                        //Last elements
                        HStack{
                            Text("Já tem uma conta?")
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                                .font(.system(size: Tokens.Fonts.Size.xs.value, weight: Tokens.Fonts.Weight.regular.value, design: Tokens.Fonts.Familiy.support.value))
                            
                            NavigationLink(destination: AccountLoginView()){
                                    Text("Faça Login!")
                            }
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .font(.system(size: Tokens.Fonts.Size.xs.value,
                                          weight: Tokens.Fonts.Weight.bold.value,
                                          design: Tokens.Fonts.Familiy.support.value))
                            //.buttonStyle(.plain)
                            
//                            Button("Faça Login!") {
//                                //Do Something Here
//                            }
//                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
//                            .font(.system(size: Tokens.Fonts.Size.xs.value, weight: Tokens.Fonts.Weight.bold.value, design: Tokens.Fonts.Familiy.support.value))
                        }
                    }
                        .padding(.vertical, Tokens.Spacing.xxs.value)
                )
        }
    }
}
