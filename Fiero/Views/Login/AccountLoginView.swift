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
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var isFieldIncorrect: Bool = false
    @State private var isRegistrationSheetShowing: Bool = false
    @State private var isShowingIncorrectLoginAlert: Bool = false
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
                                            design: .rounded)
    }
    var textFont: Font {
        return Tokens.FontStyle.caption.font()
    }
    var textButtonFont: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold,
                                             design: .rounded)
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
                        .font(titleFont)
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
                        self.userLoginViewModel.authenticateUser(email: self.emailText, password: self.passwordText)
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
            }
            .alert(isPresented: self.$isShowingIncorrectLoginAlert, content: {
                Alert(title: Text("Email invalido"), message: Text(self.serverResponse.description), dismissButton: .cancel(Text("OK")))
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
                
                self.isShowingIncorrectLoginAlert.toggle()
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
