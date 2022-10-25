//
//  OnlineOrOfflineView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 19/10/22.
//

import SwiftUI

struct OnlineOrOfflineView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var pushNextView: Bool = false
    @State var tabViewSelection: Int = 1
    
    var primaryColor: Color
    var secondaryColor: Color
    var challengeType: QCTypeEnum

    
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.edgesIgnoringSafeArea(.all)
            
            NavigationLink("", isActive: self.$pushNextView, destination: {
                QCNamingView(primaryColor: primaryColor, secondaryColor: secondaryColor, challengeType: challengeType)
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
                    CreationSmallCardView(styles: .offline)
                        .tag(2)
                        .padding(.all, Tokens.Spacing.sm.value)
                        .frame(height: UIScreen.main.bounds.height * 0.35)
                }
                .tabViewStyle(PageTabViewStyle())
                
                switch tabViewSelection {
                    case 1:
                        ButtonComponent(style: .secondary(isEnabled: true), text: "Online!") {
                            print("online")
                            pushNextView.toggle()
                        }
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    case 2:
                        ButtonComponent(style: .secondary(isEnabled: true), text: "Offline!") {
                            print("offline")
                            pushNextView.toggle()
                        }
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                    default:
                        ButtonComponent(style: .secondary(isEnabled: true), text: "Offline!") {
                            print("offline")
                            pushNextView.toggle()
                        }
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                }
                
                ButtonComponent(style: .black(isEnabled: true), text: LocalizedStringKey("backButton")) {
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct OnlineOrOfflineView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineOrOfflineView(primaryColor: .gray, secondaryColor: .purple, challengeType: .amount)
    }
}
