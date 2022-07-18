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
        ZStack {
            if #available(iOS 15.0, *) {
                Image("LoginBackground")
                    .resizable()
            } else {
                if dynamicTypeCategory > .extraExtraLarge {
                    Image("LoginBackground")
                        .resizable()
                        .saturation(0.8)
                        .blur(radius: 10, opaque: true)
                } else {
                    Image("LoginBackground")
                        .resizable()
                }
            }
            
            //MARK: Blurred View
            BlurredSquaredView(usernameText: self.$emailText) {
                VStack {
                    Text("Boas vindas, desafiante")
                        .font(titleFont)
                        .foregroundColor(.white)
                    //MARK: TextFields
                    CustomTextFieldView(type: .none,
                                        style: .primary,
                                        placeholder: emailPlaceholder,
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
                        
                        Button(action: {
                            self.isRegistrationSheetShowing.toggle()
                        }, label: {
                            Text("Cadastre-se!")
                                .font(textButtonFont)
                                .foregroundColor(color)
                        })
                    }
                    .padding(.top, smallSpacing)
                }
                .padding(smallSpacing)
            }
        }
        .alert(isPresented: self.$isShowingIncorrectLoginAlert, content: {
            Alert(title: Text("Email invalido"), message: Text(self.serverResponse.description), dismissButton: .cancel(Text("OK")))
        })
        .ignoresSafeArea()
        .onChange(of: self.userLoginViewModel.user, perform: { user in
            self.user = user
        })
        .onChange(of: self.userLoginViewModel.serverResponse, perform: { serverResponse in
            self.serverResponse = serverResponse
            
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

//MARK: - Blurred Squared View
struct BlurredSquaredView<Content>: View where Content: View {
    
    //MARK: Variables Setup
    @ViewBuilder var content: Content
    @Binding private(set) var usernameText: String
    @Environment(\.sizeCategory) var dynamicTypeCategory
        
    init(usernameText: Binding<String>, @ViewBuilder content: @escaping () -> Content) {
        self._usernameText = usernameText
        self.content = content()
    }
    
    var spacing: Double {
        return Tokens.Spacing.xxs.value
    }
    
    //MARK: body View
    var body: some View {
        if #available(iOS 15.0, *) {
            if dynamicTypeCategory >= .accessibilityMedium {
                ScrollView {
                    content
                        .frame(width: UIScreen.main.bounds.width * 0.9,
                               alignment: .center)
                        .padding(.vertical, spacing)
                        .background(.ultraThinMaterial)
                        .environment(\.colorScheme, .dark)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.white,
                                        lineWidth: 0.5)
                        )
                }
            } else {
                content
                    .frame(width: UIScreen.main.bounds.width * 0.9,
                           alignment: .center)
                    .padding(.vertical, spacing)
                    .background(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white,
                                    lineWidth: 0.5)
                    )
            }
        } else {
            if dynamicTypeCategory > .extraExtraLarge {
                ScrollView {
                    content
                        .frame(width: UIScreen.main.bounds.width * 0.9)
                        .padding(.vertical, spacing)
                }
            } else {
                ZStack {
                    Image("LoginBackground")
                        .frame(width: UIScreen.main.bounds.width * 0.9,
                               height: 437,
                               alignment: .center)
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

struct AccountLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AccountLoginView()
    }
}
