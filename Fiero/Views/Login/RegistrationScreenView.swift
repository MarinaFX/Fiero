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
    
    @EnvironmentObject var userRegistrationViewModel: UserRegistrationViewModel

    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var moving = false
    @State private var hasAcceptedTermsOfUse = false
    @State private var isShowingTermsOfUseSheet = false
    @State private var isShowingAlert: Bool = false
    @State private var isLoginScreenSheetShowing: Bool = false
    @State private var isShowingTermsOfUseAlert: Bool = false
    @State private var serverResponse: ServerResponse = .unknown
    
    @Binding private(set) var pushHomeView: Bool
    
    //MARK: - body
    var body: some View {
        if isLoginScreenSheetShowing{
            AccountLoginView(pushHomeView: self.$pushHomeView)
        } else {
            ZStack {
                Tokens.Colors.Brand.Primary.pure.value.ignoresSafeArea()
                VStack(spacing: Tokens.Spacing.xxxs.value){
                    if !userRegistrationViewModel.keyboardShown  {
                        Image("Olhos")
                            .padding(.vertical, Tokens.Spacing.sm.value)
                    }
                    VStack(spacing: Tokens.Spacing.xxs.value){
                        Text("Boas vindas, desafiante")
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .font(Tokens.FontStyle.title3.font(weigth: .bold,
                                                               design: .rounded))
                        //MARK: TextFilds elements
                        VStack(spacing: Tokens.Spacing.xxxs.value){
                            CustomTextFieldView(type: .none, style: .primary, helperText: "", placeholder: "Nome", isLowCase: false , isWrong: .constant(false), text: $username)
                            
                            CustomTextFieldView(type: .none, style: .primary, helperText: "", placeholder: "E-mail", keyboardType: .emailAddress, isLowCase: true ,isWrong: .constant(false), text: $email)
                            
                            CustomTextFieldView(type: .both, style: .primary, helperText: "", placeholder: "Senha", isLowCase: true ,isWrong: .constant(false), text: $password)
                        }
                        //MARK: Button and CheckBox
                        CheckboxComponent(style: .dark,
                                          text: "Concordo com os",
                                          linkedText: "Termos de Uso",
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
                            if hasAcceptedTermsOfUse == true {
                                isShowingTermsOfUseAlert = false
                                if !self.username.isEmpty && !self.email.isEmpty && !self.password.isEmpty {
                                    self.userRegistrationViewModel.createUserOnDatabase(for: User(email: self.email, name: self.username, password: self.password))
                                }
                                else {
                                    self.userRegistrationViewModel.registrationAlertCases = .emptyFields
                                    self.isShowingAlert.toggle()
                                }
                            } else {
                                self.isShowingTermsOfUseAlert = true
                            }
                        })
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
                    .padding(.horizontal, Tokens.Spacing.xxxs.value)
            }
            .alert(isPresented: self.$isShowingAlert, content: {
                switch userRegistrationViewModel.registrationAlertCases {
                case .emptyFields:
                    return Alert(title: Text(RegistrationAlertCases.emptyFields.title),
                                 message: Text(RegistrationAlertCases.emptyFields.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.userRegistrationViewModel.serverResponse = .unknown
                    })
                case .invalidEmail:
                    return Alert(title: Text(RegistrationAlertCases.invalidEmail.title),
                                 message: Text(RegistrationAlertCases.invalidEmail.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.userRegistrationViewModel.serverResponse = .unknown
                    })
                case .accountAlreadyExists:
                    return Alert(title: Text(RegistrationAlertCases.accountAlreadyExists.title),
                                 message: Text(RegistrationAlertCases.accountAlreadyExists.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.userRegistrationViewModel.serverResponse = .unknown
                    })
                case .connectionError:
                    return Alert(title: Text(RegistrationAlertCases.connectionError.title),
                                 message: Text(RegistrationAlertCases.connectionError.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.userRegistrationViewModel.serverResponse = .unknown
                    })
                }
            })
            .alert(isPresented: $isShowingTermsOfUseAlert, content: {
                Alert(title: Text("Termos de Uso"),
                      message: Text("Você deve ler e aceitar os termos de uso para poder criar uma conta."),
                      dismissButton: .cancel(Text("OK")))
                
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                userRegistrationViewModel.onKeyboardDidSHow()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                userRegistrationViewModel.onKeyboardDidHide()
            }
            .navigationBarHidden(true)
            .onChange(of: self.userRegistrationViewModel.serverResponse, perform: { serverResponse in
                self.serverResponse = serverResponse
                
                if self.serverResponse.statusCode == 200 ||
                    self.serverResponse.statusCode == 201 {
                    UserDefaults.standard.set(self.password, forKey: "password")
                    UserDefaults.standard.set(self.email, forKey: "email")
                    self.userRegistrationViewModel.saveUserOnUserDefaults(name: username)
                    self.pushHomeView.toggle()
                }
                
                if self.serverResponse.statusCode == 400 {
                    userRegistrationViewModel.registrationAlertCases = .invalidEmail
                    isShowingAlert.toggle()
                }
                
                if self.serverResponse.statusCode == 409 {
                    userRegistrationViewModel.registrationAlertCases = .accountAlreadyExists
                    isShowingAlert.toggle()
                }
                
                if self.serverResponse.statusCode == 500 {
                    userRegistrationViewModel.registrationAlertCases = .connectionError
                    isShowingAlert.toggle()
                }
            })
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
                AppDelegate.orientationLock = .portrait // And making sure it stays that way
            }.onDisappear {
                AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
            }
            .preferredColorScheme(.dark)
        }
    }
}
