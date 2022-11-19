//
//  OnlineOrOfflineView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 19/10/22.
//

import SwiftUI

struct OnlineOrOfflineView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var presentNextScreen: Bool = false
    @State var tabViewSelection: Int = 1
    @State var isOnline: Bool = false
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCTypeEnum

    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
                
                NavigationLink("", isActive: self.$presentNextScreen, destination: {
                    QCNamingView(isOnline: isOnline, primaryColor: primaryColor, secondaryColor: secondaryColor, challengeType: challengeType)
                })
                .hidden()
                
                VStack {
                    CustomProgressBar(currentPage: .first)
                        .padding()
                    
                    Text(LocalizedStringKey("screenTitle"))
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .semibold, design: .rounded))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                    
                    TabView(selection: $tabViewSelection) {
                        CreationSmallCardView(styles: .online)
                            .tag(1)
                            .padding(.all, Tokens.Spacing.sm.value)
                            .frame(height: UIScreen.main.bounds.height * 0.35)
                            .onTapGesture {
                                isOnline = true
                                presentNextScreen = true
                            }
                        CreationSmallCardView(styles: .offline)
                            .tag(2)
                            .padding(.all, Tokens.Spacing.sm.value)
                            .frame(height: UIScreen.main.bounds.height * 0.35)
                            .onTapGesture {
                                isOnline = false
                                presentNextScreen = true
                            }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    
                    switch tabViewSelection {
                        case 1:
                            ButtonComponent(style: .secondary(isEnabled: true), text: "Online!") {
                                isOnline = true
                                presentNextScreen = true
                            }
                            .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                        default:
                            ButtonComponent(style: .secondary(isEnabled: true), text: "Offline!") {
                                isOnline = false
                                presentNextScreen = true
                            }
                            .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    }
                    
                    ButtonComponent(style: .black(isEnabled: true), text: LocalizedStringKey("backButton")) {
                        self.dismiss()
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct OnlineOrOfflineView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineOrOfflineView(primaryColor: .gray, secondaryColor: .purple, challengeType: .amount)
    }
}
