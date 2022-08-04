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
    @Environment(\.sizeCategory) var dynamicTypeCategory
    
    @StateObject private var userRegistrationViewModel = UserRegistrationViewModel()
    
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var moving = false
    @State private var hasAcceptedTermsOfUse = false
    @State private var isShowingTermsOfUseSheet = false
    @State private var isShowingInvalidInputAlert: Bool = false
    @State private var isLoginScreenSheetShowing: Bool = false
    @State private var serverResponse: ServerResponse = .unknown
    
    @Binding private(set) var pushHomeView: Bool
    
    //MARK: - body
    var body: some View {
        if isLoginScreenSheetShowing{
            AccountLoginView(pushHomeView: self.$pushHomeView)
        }else{
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
                            //MARK: TextFilds elements
                            VStack(spacing: Tokens.Spacing.xxxs.value){
                                CustomTextFieldView(type: .none, style: .primary, helperText: "", placeholder: "Nome", isLowCase: false , isWrong: .constant(false), text: $username)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                                
                                CustomTextFieldView(type: .none, style: .primary, helperText: "", placeholder: "E-mail", keyboardType: .emailAddress, isLowCase: true ,isWrong: .constant(false), text: $email)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                                
                                CustomTextFieldView(type: .both, style: .primary, helperText: "", placeholder: "Senha", isLowCase: true ,isWrong: .constant(false), text: $password)
                                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
                            }
                            //MARK: Button and CheckBox
                            CheckboxComponent(style: .dark,
                                              text: "Concordo com os",
                                              linkedText: "termos de uso",
                                              isChecked: $hasAcceptedTermsOfUse,
                                              checkboxHandler: { isChecked in
                                print(isChecked)
                            },
                                              linkedTextHandler: {
                                isShowingTermsOfUseSheet.toggle()
                            })
                            .sheet(isPresented: $isShowingTermsOfUseSheet) {
                                TermsOfUseSheetView(termsOfUseAccept: $hasAcceptedTermsOfUse)
                            }
                            
                            ButtonComponent(style: .secondary(isEnabled: true),
                                            text: "Criar conta!",
                                            action: {
                                if !self.username.isEmpty && !self.email.isEmpty && !self.password.isEmpty {
                                    self.userRegistrationViewModel.createUserOnDatabase(for: User(email: self.email, name: self.username, password: self.password))
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
                                isLoginScreenSheetShowing.toggle()
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .font(Tokens.FontStyle.callout.font(weigth: .bold))
                        }
                    }
                }
            }
            .alert(isPresented: self.$isShowingInvalidInputAlert, content: {
                Alert(title: Text("Email invalido"),
                      message: Text(self.serverResponse.description),
                      dismissButton: .cancel(Text("OK")))
            })
            .ignoresSafeArea()
            .navigationBarHidden(true)
            .onChange(of: self.userRegistrationViewModel.serverResponse, perform: { serverResponse in
                self.serverResponse = serverResponse
                
                if self.serverResponse.statusCode == 200 ||
                    self.serverResponse.statusCode == 201 {
                    self.pushHomeView.toggle()
                }
                
                self.isShowingInvalidInputAlert.toggle()
            })
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
                AppDelegate.orientationLock = .portrait // And making sure it stays that way
            }.onDisappear {
                AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
            }
        }
    }
}

//MARK: - GlassPhormism
struct GlassPhormism<Content>: View where Content: View {
    //MARK: - Variables Setup
    
    @ViewBuilder var content: Content
    @Environment(\.sizeCategory) var dynamicTypeCategory
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    //MARK: - body
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
