//
//  RegistrationScreen.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 07/07/22.
//

import SwiftUI
import Combine

//MARK: UserSignupView
struct UserSignupView: View {
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.sizeCategory) var dynamicTypeCategory
    
    @EnvironmentObject var userViewModel: UserViewModel

    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var moving = false
    @State private var hasAcceptedTermsOfUse = false
    @State private var isShowingTermsOfUseSheet = false
    @State private var isShowingAlert: Bool = false
    @State private var isLoginScreenSheetShowing: Bool = false
    @State private var isShowingTermsOfUseAlert: Bool = false
    @State private var subscriptions: Set<AnyCancellable> = []

    
    //MARK: - body
    var body: some View {
        if isLoginScreenSheetShowing{
            AccountLoginView()
        } else {
            ZStack {
                Tokens.Colors.Brand.Primary.pure.value.ignoresSafeArea()
                VStack(spacing: Tokens.Spacing.xxxs.value){
                    if !self.userViewModel.keyboardShown  {
                        Image("Olhos")
                            .padding(.vertical, Tokens.Spacing.sm.value)
                    }
                    VStack(spacing: Tokens.Spacing.xxs.value){
                        Text("Boas vindas, desafiante")
                            .multilineTextAlignment(.center)
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .font(Tokens.FontStyle.title.font(weigth: .bold,
                                                               design: .default))
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
                                    self.userViewModel.signup(for: User(email: self.email, name: self.username, password: self.password))
                                }
                                else {
                                    self.userViewModel.signupAlertCases = .emptyFields
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
                if self.userViewModel.isShowingLoading {
                    ZStack {
                        Tokens.Colors.Neutral.Low.pure.value.edgesIgnoringSafeArea(.all).opacity(0.9)
                        VStack {
                            Spacer()
                            //TODO: - change name of animation loading
                            LottieView(fileName: "loading", reverse: false, loop: true).frame(width: 200, height: 200)
                            Spacer()
                        }
                    }
                }
            }
            .alert(isPresented: self.$isShowingAlert, content: {
                switch self.userViewModel.signupAlertCases {
                case .emptyFields:
                    return Alert(title: Text(SignupAlertCases.emptyFields.title),
                                 message: Text(SignupAlertCases.emptyFields.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.isShowingAlert = false
                        self.userViewModel.removeLoadingAnimation()
                    })
                case .invalidEmail:
                    return Alert(title: Text(SignupAlertCases.invalidEmail.title),
                                 message: Text(SignupAlertCases.invalidEmail.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.isShowingAlert = false
                        self.userViewModel.removeLoadingAnimation()
                    })
                case .accountAlreadyExists:
                    return Alert(title: Text(SignupAlertCases.accountAlreadyExists.title),
                                 message: Text(SignupAlertCases.accountAlreadyExists.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.isShowingAlert = false
                        self.userViewModel.removeLoadingAnimation()
                    })
                case .connectionError:
                    return Alert(title: Text(SignupAlertCases.connectionError.title),
                                 message: Text(SignupAlertCases.connectionError.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.isShowingAlert = false
                        self.userViewModel.removeLoadingAnimation()
                    })
                }
            })
            .alert(isPresented: $isShowingTermsOfUseAlert, content: {
                Alert(title: Text("Termos de Uso"),
                      message: Text("Você deve ler e aceitar os termos de uso para poder criar uma conta."),
                      dismissButton: .cancel(Text("OK")))
                
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                userViewModel.onKeyboardDidSHow()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                userViewModel.onKeyboardDidHide()
            }
            .navigationBarHidden(true)
            .onReceive(self.userViewModel.$signupAlertCases.dropFirst(), perform: { error in
                let error = error
                
                if error == .invalidEmail {
                    self.isShowingAlert = true
                }
                
                if error == .accountAlreadyExists {
                    self.isShowingAlert = true
                }
                
                if error == .connectionError {
                    self.isShowingAlert = true
                }
                
                self.userViewModel.isLogged = true
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
