//
//  Onboarding.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 28/08/22.
//

import Foundation
import SwiftUI

struct OnboardingScreen: View {
    @Environment(\.dynamicTypeSize) var dynamicType
    @Binding var isFirstLogin: Bool
    @State private var selectedItem: Int = 0
    
    var pages: [OnboardingCard] = [OnboardingCard(image: "firstImage",
                                                  degrees: 3.18,
                                                  title: "firstTitle",
                                                  description: "firstDescription"),
                                   OnboardingCard(image: "secondImage",
                                                  degrees: -3.55,
                                                  title: "secondTitle",
                                                  description: "secondDescription"),
                                   OnboardingCard(image: "thirdImage",
                                                  degrees: 3.55,
                                                  title: "thirdTitle",
                                                  description: "thirdDescription")]
    var body: some View {
        ZStack {
            Tokens.Colors.Background.dark.value.ignoresSafeArea()
            VStack() {
                TabView(selection: $selectedItem) {
                    ForEach(0 ..< pages.count) { index in
                        if dynamicType >= .accessibility1 {
                            ScrollView {
                                OnboardingCard(image: pages[index].image,
                                               degrees: pages[index].degrees,
                                               title: pages[index].title,
                                               description: pages[index].description)
                            }
                        }
                        else {
                            OnboardingCard(image: pages[index].image,
                                           degrees: pages[index].degrees,
                                           title: pages[index].title,
                                           description: pages[index].description)
                        }
                    }
                }
                .padding(.vertical, 0)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                if selectedItem == 2 {
                    ButtonComponent(style: .tertiary(isEnabled: true),
                                    text: "Quero começar!") {
                        self.isFirstLogin.toggle()
                    }
                    .padding(.bottom, Tokens.Spacing.defaultMargin.value)
                    .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                }
                else {
                    ButtonComponent(style: .tertiary(isEnabled: true),
                                    text: "Quero começar!") {
                        self.isFirstLogin = true
                    }
                    .padding(.bottom, Tokens.Spacing.defaultMargin.value)
                    .padding(.horizontal, Tokens.Spacing.lg.value)
                    .hidden()
                }
            }
            .padding(.top, Tokens.Spacing.defaultMargin.value)
            VStack {
                HStack {
                    Spacer()
                    Button {
                        self.isFirstLogin.toggle()
                    } label: {
                        Text("Pular")
                            .font(Tokens.FontStyle.callout.font())
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    }
                    .padding(.top ,Tokens.Spacing.defaultMargin.value)
                    .padding(.trailing, Tokens.Spacing.defaultMargin.value)
                }
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct OnboardingScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreen(isFirstLogin: .constant(false))
    }
}

