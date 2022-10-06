//
//  AccountLoginView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 07/07/22.
//

import SwiftUI
import Combine

//MARK: - Account Login View
struct AccountLoginView: View {
    
    //MARK: - Variables Setup
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.sizeCategory) var dynamicTypeCategory
    
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var userViewModelSignup: UserViewModel
    
    
    //MARK: - Variables Login View
    @State private(set) var user: User = .init(email: "", name: "", password: "")
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var isFieldIncorrect: Bool = false
    @State private var isShowingSignupSheet: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var subscriptions: Set<AnyCancellable> = []
    
    private let namePlaceholder: String = "Name"
    private let emailPlaceholder: String = "E-mail"
    private let passwordPlaceholder: String = "Senha"
    
    //MARK: - Variables Sigup View
    @State private var email: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var moving = false
    @State private var hasAcceptedTermsOfUse = false
    @State private var isShowingTermsOfUseSheet = false
    @State private var isLoginScreenSheetShowing: Bool = false
    @State private var isShowingTermsOfUseAlert: Bool = false
    
    var nanoSpacing: Double {
        return Tokens.Spacing.nano.value
    }
    var smallSpacing: Double {
        return Tokens.Spacing.xxxs.value
    }
    var SmSpacing: Double {
        return Tokens.Spacing.sm.value
    }
    
    var color: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    var titleFont: Font {
        return Tokens.FontStyle.title3.font(weigth: .bold,
                                            design: .default)
    }
    var largeTitleFont: Font {
        return Tokens.FontStyle.title.font(weigth: .bold,
                                            design: .default)
    }
    var textFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    var textButtonFont: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold,
                                             design: .default)
    }
    
    //MARK: body View
    var body: some View {
        
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            
            //MARK: Login Form
            VStack {
                if !userViewModel.keyboardShown  {
                    LottieView(fileName: "LoginAnimationStart", reverse: false, loop: false, aspectFill: false, secondAnimation: "LoginAnimationEnd", loopSecond: true)
                }
                Text("Boas vindas, desafiante")
                    .font(largeTitleFont)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.vertical, smallSpacing)
                
                if isShowingSignupSheet{
                    //MARK: - Sigup View
                    Group{
                        //MARK: TextFilds elements
                        VStack(spacing: Tokens.Spacing.xxxs.value){
                            CustomTextFieldView(type: .none, style: .primary, helperText: "", placeholder: "Nome", isLowCase: false , isWrong: .constant(false), text: $username)
                            
                            CustomTextFieldView(type: .none, style: .primary, helperText: "", placeholder: "E-mail", keyboardType: .emailAddress, isLowCase: true ,isWrong: .constant(false), text: $email)
                            
                            CustomTextFieldView(type: .both,style: .primary, helperText: "", placeholder: "Senha", isSecure: true, isLowCase: true ,isWrong: .constant(false), text: $password)
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
                            print(username)
                            print(email)
                            print(password)
                            if self.username.isEmpty || self.email.isEmpty || self.password.isEmpty {
                                self.userViewModel.loginAlertCases = .emptyFields
                                isShowingAlert.toggle()
                            } else if !self.email.contains("@") || !self.email.contains("."){
                                self.userViewModel.loginAlertCases = .invalidEmail
                                isShowingAlert.toggle()
                            } else if !hasAcceptedTermsOfUse {
                                self.userViewModel.loginAlertCases = .termsOfUse
                                isShowingAlert.toggle()
                            } else {
                                self.userViewModelSignup.signup(for: User(email: self.email, name: self.username, password: self.password))
                            }
                        })
                        //MARK: Last elements
                        HStack{
                            Text("Já tem uma conta?")
                                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                                .font(Tokens.FontStyle.callout.font())
                            Button("Faça Login!") {
                                self.isShowingSignupSheet.toggle()
                            }
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .font(Tokens.FontStyle.callout.font(weigth: .bold))
                        }
                    }
                } else {
                    //MARK: - Login View
                    Group{
                        //MARK: TextFields
                        CustomTextFieldView(type: .none,
                                            style: .primary,
                                            placeholder: emailPlaceholder,
                                            keyboardType: .emailAddress,
                                            isSecure: false,
                                            isLowCase: true ,
                                            isWrong: .constant(false),
                                            text: self.$emailText)
                        
                        
                        CustomTextFieldView(type: .icon,
                                            style: .primary,
                                            placeholder: passwordPlaceholder,
                                            isSecure: true,
                                            isLowCase: true ,
                                            isWrong: .constant(false),
                                            text: self.$passwordText)
                        .padding(.vertical, nanoSpacing)
                        //MARK: Buttons
                        ButtonComponent(style: .secondary(isEnabled: true),
                                        text: "Fazer Login!",
                                        action: {
                            if emailText.isEmpty || passwordText.isEmpty {
                                self.userViewModel.loginAlertCases = .emptyFields
                                isShowingAlert.toggle()
                            } else if !emailText.contains("@") || !emailText.contains("."){
                                self.userViewModel.loginAlertCases = .invalidEmail
                                isShowingAlert.toggle()
                            } else {
                                self.userViewModel.login(email: self.emailText, password: self.passwordText)
                            }
                        })
                        
                        HStack {
                            Text("Ainda não tem uma conta?")
                                .font(textFont)
                                .foregroundColor(color)
                                .accessibilityLabel("")
                            
                            Button(action: {
                                self.isShowingSignupSheet.toggle()
                            }, label: {
                                Text("Cadastre-se!")
                                    .font(textButtonFont)
                                    .foregroundColor(color)
                                    .accessibilityLabel("Ainda não tem uma conta? Cadastre-se!")
                            })
                        }
                        .padding(.top, smallSpacing)
                    }
                }
            }
            .padding(.horizontal, smallSpacing)
            if userViewModel.isShowingLoading {
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
            switch self.userViewModel.loginAlertCases {
            case .emptyFields:
                return Alert(title: Text(LoginAlertCases.emptyFields.title),
                             message: Text(LoginAlertCases.emptyFields.message),
                             dismissButton: .cancel(Text("OK")) {
                    self.isShowingAlert = false
                    self.userViewModel.removeLoadingAnimation()
                })
            case .invalidEmail:
                return Alert(title: Text(LoginAlertCases.invalidEmail.title),
                             message: Text(LoginAlertCases.invalidEmail.message),
                             dismissButton: .cancel(Text("OK")) {
                    self.isShowingAlert = false
                    self.userViewModel.removeLoadingAnimation()
                })
            case .wrongCredentials:
                return Alert(title: Text(LoginAlertCases.wrongCredentials.title),
                             message: Text(LoginAlertCases.wrongCredentials.message),
                             dismissButton: .cancel(Text("OK")) {
                    self.isShowingAlert = false
                    self.userViewModel.removeLoadingAnimation()
                })
            case .connectionError:
                return Alert(title: Text(LoginAlertCases.connectionError.title),
                             message: Text(LoginAlertCases.connectionError.message),
                             dismissButton: .cancel(Text("OK")) {
                    self.isShowingAlert = false
                    self.userViewModel.removeLoadingAnimation()
                })
            case .emailNotRegistrated:
                return Alert(title: Text(LoginAlertCases.emailNotRegistrated.title),
                             message: Text(LoginAlertCases.emailNotRegistrated.message),
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
            case .termsOfUse:
                return Alert(title: Text(SignupAlertCases.termsOfUse.title),
                             message: Text(SignupAlertCases.termsOfUse.message),
                             dismissButton: .cancel(Text("OK")) {
                    self.isShowingAlert = false
                    self.userViewModel.removeLoadingAnimation()
                })
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
            self.userViewModel.onKeyboardDidSHow()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
            self.userViewModel.onKeyboardDidHide()
        }
        .onChange(of: self.userViewModel.user, perform: { user in
            self.user = user
        })
        .onReceive(self.userViewModel.$loginAlertCases.dropFirst(), perform: { error in
            let error = error
            
            if error == .invalidEmail {
                self.isShowingAlert = true
            }
            
            if error == .wrongCredentials {
                self.isShowingAlert = true
            }
            
            if error == .emailNotRegistrated {
                self.isShowingAlert = true
            }
            
            if error == .connectionError {
                self.isShowingAlert = true
            }
            
            if error == .accountAlreadyExists {
                self.isShowingAlert = true
            }
        })
        .onAppear {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
            AppDelegate.orientationLock = .portrait // And making sure it stays that way
            
            let defaults = UserDefaults.standard
            
            let email = defaults.string(forKey: UDKeys.email.description) ?? ""
            let password = defaults.string(forKey: UDKeys.password.description) ?? ""
            
            if (!(email.isEmpty) || !(password.isEmpty))  {
                self.userViewModel.isLogged = true
            }
            
        }.onDisappear {
            // Unlocking the rotation when leaving the view
            // AppDelegate.orientationLock = .all
        }
        .preferredColorScheme(.dark)
    }
}


struct AccountLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AccountLoginView()
    }
}
