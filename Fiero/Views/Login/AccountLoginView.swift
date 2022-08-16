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
    
    @StateObject private var userLoginViewModel: UserLoginViewModel = UserLoginViewModel()
    
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
        }else{
            ZStack {
                //MARK: Login Form
                VStack {
                    Spacer()
                    Text("Boas vindas, desafiante")
                        .font(titleFont)
                        .foregroundColor(.white)
                    //MARK: TextFields
                    CustomTextFieldView(type: .none,
                                        style: .primary,
                                        placeholder: emailPlaceholder,
                                        keyboardType: .emailAddress,
                                        isSecure: false,
                                        isLowCase: true ,
                                        isWrong: .constant(false),
                                        text: self.$emailText)
                        .padding(nanoSpacing)
                    
                    CustomTextFieldView(type: .icon,
                                        style: .primary,
                                        placeholder: passwordPlaceholder,
                                        isSecure: true,
                                        isLowCase: true ,
                                        isWrong: .constant(false),
                                        text: self.$passwordText)
                        .padding(nanoSpacing)
                    //MARK: Buttons
                    Button(action: {
                        //TODO: create a link to Remember Password Screen (doesn't exist yet)
                    }, label: {
                        Text("Esqueceu sua senha?")
                            .font(textFont)
                            .foregroundColor(color)
                            .underline()
                    })
                    .padding(.vertical, smallSpacing)
                    
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
                .padding(smallSpacing)
            }
            .background(
                Image("LoginBackground")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                    .scaledToFill()
                    )
            .alert(isPresented: self.$isShowingIncorrectLoginAlert, content: {
                Alert(title: Text("Email invalido"), message: Text(self.serverResponse.description), dismissButton: .cancel(Text("OK")))
            })
            .onChange(of: self.userLoginViewModel.user, perform: { user in
                self.user = user
            })
            .onChange(of: self.userLoginViewModel.serverResponse, perform: { serverResponse in
                self.serverResponse = serverResponse
                
                if self.serverResponse.statusCode == 200 ||
                    self.serverResponse.statusCode == 201 {
                    UserDefaults.standard.set(self.passwordText, forKey: "password")
                    UserDefaults.standard.set(self.emailText, forKey: "email")
                    self.pushHomeView.toggle()
                }
                
                self.isShowingIncorrectLoginAlert.toggle()
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

struct AccountLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AccountLoginView(pushHomeView: .constant(false))
    }
}
