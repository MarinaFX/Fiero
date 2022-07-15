//
//  RegistrationScreen.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/07/22.
//

import SwiftUI

struct RegistrationScreenView: View {
    //MARK: Variables Setup
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.sizeCategory) var dynamicTypeCategory
    
    @StateObject var userRegistrationViewModel = UserRegistrationViewModel()
    @State private var showingTermsOfUseSheet = false
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State var moving = false
    @State var termsOfUseAccept = false
    
    //MARK: body
    var body: some View {
        NavigationView {
            ZStack {
                if #available(iOS 15.0, *) {
                    Image("LoginBackground")
                        .resizable()
                } else {
                    if dynamicTypeCategory > .extraExtraLarge  {
                        Image("LoginBackground")
                            .resizable()
                            .saturation(0.8)
                            .blur(radius: 10, opaque: true)
                    } else {
                        Image("LoginBackground")
                            .resizable()
                    }
                }
                GlassPhormism {
                    VStack(spacing: Tokens.Spacing.xxxs.value){
                        VStack(spacing: Tokens.Spacing.xxs.value){
                            Text("Boas vindas, desafiante")
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                                .font(Tokens.FontStyle.title3.font(weigth: .bold,
                                                                   design: .rounded))
                            //TextFilds elements
                            VStack(spacing: Tokens.Spacing.xxxs.value){
                                CustomTextFieldView(type: .none, style: .primary, placeholder: "Nome", helperText: "", isWrong: .constant(false), text: $username)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                                
                                CustomTextFieldView(type: .none, style: .primary, placeholder: "E-mail", helperText: "", isWrong: .constant(false), text: $email)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                                
                                CustomTextFieldView(type: .both, style: .primary, placeholder: "Senha", helperText: "", isWrong: .constant(false), text: $password)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                            }
                            //MARK: - Button and CheckBox
                            CheckboxComponent(style: .dark,
                                              text: "Concordo com os",
                                              linkedText: "termos de uso",
                                              isChecked: $termsOfUseAccept,
                                              checkboxHandler: { isChecked in
                                //TODO: - Handle isChecked
                                print(isChecked)
                            }, linkedTextHandler: {
                                showingTermsOfUseSheet.toggle()
                            })
                            .sheet(isPresented: $showingTermsOfUseSheet) {
                                TermsOfUseSheetView(termsOfUseAccept: $termsOfUseAccept)
                            }
                            
                            ButtonComponent(style: .secondary(isEnabled: true),
                                            text: "Criar conta!",
                                            action: {
                                if !self.username.isEmpty && !self.email.isEmpty && !self.password.isEmpty {
                                    self.userRegistrationViewModel.createUserOnDatabase(for: User(email: self.email, name: self.username, password: self.password)) { response in
                                        if response == .userCreated {
                                            
                                        }
                                        else {
                                            //TODO: present error while creating account alert
                                        }
                                    }
                                }
                            })
                            .padding(.horizontal, Tokens.Spacing.xxs.value)
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
            .navigationBarHidden(true)
        }.onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .portrait // And making sure it stays that way
        }.onDisappear {
            AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
        }
    }
}

struct GlassPhormism<Content>: View where Content: View {
    //MARK: Variables Setup
    
    @ViewBuilder var content: Content
    @Environment(\.sizeCategory) var dynamicTypeCategory
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    //MARK: body
    var body: some View {
        
        if #available(iOS 15.0, *) {
            if dynamicTypeCategory >= .accessibilityMedium  {
                ScrollView {
                    content
                        .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
                        .padding(.vertical, Tokens.Spacing.xxs.value)
                        .background(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 0.5)
                        )
                }
            } else {
                content
                    .frame(width: UIScreen.main.bounds.width * 0.9, alignment: .center)
                    .padding(.vertical, Tokens.Spacing.xxs.value)
                    .background(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 0.5)
                    )
            }
        }
        else {
            if dynamicTypeCategory > .extraExtraLarge  {
                ScrollView {
                    content
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.vertical, Tokens.Spacing.xxs.value)
                }
            } else {
                ZStack {
                    Image("LoginBackground")
                        //.resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 437,alignment: .center)
                        .blur(radius: 10)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white, lineWidth: 0.5)
                        )
                        .overlay(
                            content
                        )
                }
            }
        }
    }
}
