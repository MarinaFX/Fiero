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
    @Environment(\.sizeCategory) var dynamicTypeCategory

    @EnvironmentObject var userLoginViewModel: UserLoginViewModel
    @EnvironmentObject var userRegistrationViewModel: UserRegistrationViewModel

    @State private(set) var user: User = .init(email: "", name: "", password: "")
    @State private var emailText: String = "lelod15@gmail.com"
    @State private var passwordText: String = "lelo"
    @State private var isFieldIncorrect: Bool = false
    @State private var isRegistrationSheetShowing: Bool = false
    @State private var isShowingAlert: Bool = false
    @State private var serverResponse: ServerResponse = .unknown

    @Binding private(set) var pushHomeView: Bool

    private let namePlaceholder: String = "Name"
    private let emailPlaceholder: String = "E-mail"
    private let passwordPlaceholder: String = "Senha"
    
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
        if isRegistrationSheetShowing{
            RegistrationScreenView(pushHomeView: self.$pushHomeView)
                .environmentObject(self.userRegistrationViewModel)
        }else{
            ZStack {
                Tokens.Colors.Brand.Primary.pure.value.ignoresSafeArea()
                //MARK: Login Form
                VStack {
                    if !userLoginViewModel.keyboardShown  {
                        Image("Olhos")
                            .padding(.vertical, Tokens.Spacing.sm.value)
                    }
                    Text("Boas vindas, desafiante")
                        .font(largeTitleFont)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.vertical, smallSpacing)
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
                                    text: "Fazer login!",
                                    action: {
                        if emailText.isEmpty || passwordText.isEmpty {
                            userLoginViewModel.loginAlertCases = .emptyFields
                            isShowingAlert.toggle()
                        }
                        else {
                            self.userLoginViewModel.authenticateUser(email: self.emailText, password: self.passwordText)
                        }
                    })
                    
                    HStack {
                        Text("Ainda não tem uma conta?")
                            .font(textFont)
                            .foregroundColor(color)
                            .accessibilityLabel("")
                        
                        Button(action: {
                            self.isRegistrationSheetShowing.toggle()
                        }, label: {
                            Text("Cadastre-se!")
                                .font(textButtonFont)
                                .foregroundColor(color)
                                .accessibilityLabel("Ainda não tem uma conta? Cadastre-se!")
                        })
                    }
                    .padding(.top, smallSpacing)
                }
                .padding(.horizontal, smallSpacing)
                if userLoginViewModel.isShowingLoading {
                    ZStack {
                        Tokens.Colors.Neutral.Low.pure.value.edgesIgnoringSafeArea(.all).opacity(0.9)
                        VStack {
                            Spacer()
                            //TODO: - change name of animation loading
                            LottieView(fileName: "loading", reverse: false, loop: false).frame(width: 200, height: 200)
                            Spacer()
                        }
                    }
                }
            }
            .alert(isPresented: self.$isShowingAlert, content: {
                switch userLoginViewModel.loginAlertCases {
                case .emptyFields:
                    return Alert(title: Text(LoginAlertCases.emptyFields.title),
                                 message: Text(LoginAlertCases.emptyFields.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.userLoginViewModel.serverResponse = .unknown
                        userLoginViewModel.removeLoadingAnimation()
                    })
                case .invalidEmail:
                    return Alert(title: Text(LoginAlertCases.invalidEmail.title),
                                 message: Text(LoginAlertCases.invalidEmail.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.userLoginViewModel.serverResponse = .unknown
                        userLoginViewModel.removeLoadingAnimation()
                    })
                case .loginError:
                    return Alert(title: Text(LoginAlertCases.loginError.title),
                                        message: Text(LoginAlertCases.loginError.message),
                                        dismissButton: .cancel(Text("OK")) {
                        self.userLoginViewModel.serverResponse = .unknown
                        userLoginViewModel.removeLoadingAnimation()
                    })
                case .connectionError:
                    return Alert(title: Text(LoginAlertCases.connectionError.title),
                                 message: Text(LoginAlertCases.connectionError.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.userLoginViewModel.serverResponse = .unknown
                        userLoginViewModel.removeLoadingAnimation()
                    })
                case .emailNotRegistrated:
                    return Alert(title: Text(LoginAlertCases.emailNotRegistrated.title),
                                 message: Text(LoginAlertCases.emailNotRegistrated.message),
                                 dismissButton: .cancel(Text("OK")) {
                        self.userLoginViewModel.serverResponse = .unknown
                        userLoginViewModel.removeLoadingAnimation()
                    })
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                userLoginViewModel.onKeyboardDidSHow()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                userLoginViewModel.onKeyboardDidHide()
            }
            .onChange(of: self.userLoginViewModel.user, perform: { user in
                self.user = user
            })
            .onChange(of: self.userLoginViewModel.serverResponse, perform: { serverResponse in
                self.serverResponse = serverResponse
                
                if self.serverResponse.statusCode == 200 ||
                    self.serverResponse.statusCode == 201 {
                    self.userLoginViewModel.setUserOnDefaults(email: self.emailText, password: self.passwordText)
                    self.userRegistrationViewModel.saveUserOnUserDefaults(name: user.name)
                    self.pushHomeView.toggle()
                }
                
                if self.serverResponse.statusCode == 400 {
                    userLoginViewModel.loginAlertCases = .invalidEmail
                    isShowingAlert.toggle()
                }
                
                if self.serverResponse.statusCode == 403 {
                    userLoginViewModel.loginAlertCases = .loginError
                    isShowingAlert.toggle()
                }
                
                if self.serverResponse.statusCode == 404 {
                    userLoginViewModel.loginAlertCases = .emailNotRegistrated
                    isShowingAlert.toggle()
                }
                
                if self.serverResponse.statusCode == 500 {
                    userLoginViewModel.loginAlertCases = .connectionError
                    isShowingAlert.toggle()
                }
            })
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
                AppDelegate.orientationLock = .portrait // And making sure it stays that way
                
                typealias UserFromDefaults = (email: String, pasasword: String)
                
                let user = self.userLoginViewModel.getUserFromDefaults()
                
                if user.email != nil && user.password != nil {
                    self.userLoginViewModel.authenticateUser(email: user.email!, password: user.password!)
                }
                
            }.onDisappear {
                AppDelegate.orientationLock = .all // Unlocking the rotation when leaving the view
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct AccountLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AccountLoginView(pushHomeView: .constant(false))
    }
}
