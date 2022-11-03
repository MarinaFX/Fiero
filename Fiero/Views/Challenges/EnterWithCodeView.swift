//
//  EnterWithCode.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/10/22.
//

import SwiftUI
import Combine

struct EnterWithCodeView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @State var isPresentingQRCodeReader: Bool = false
    
    @State private var challengeCode: String = ""
    @State private var isShowingErrorAlert: Bool = false
    @State private var subscriptions: Set<AnyCancellable> = []
    @State private var challengeCodeArray: [String] = ["_", "_", "_", "_", "_"]
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value
                    .edgesIgnoringSafeArea(.all)
                ScrollView (showsIndicators: false) {
                    VStack(spacing: Tokens.Spacing.xs.value) {
                        Spacer()
                        
                        Text(LocalizedStringKey("enterWithCodeDescription"))
                            .multilineTextAlignment(.center)
                            .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                            .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                            .padding(.horizontal, Tokens.Spacing.md.value)
                        
                        VStack(spacing: Tokens.Spacing.xxxs.value) {
                            
                            ZStack {
                                HStack {
                                    TextField("", text: $challengeCode.max(5))
                                        .disableAutocorrection(true)    
                                        .textCase(.uppercase)
                                        .opacity(0)
                                        .foregroundColor(.clear)
                                        .focused($keyboardFocused)
                                        .onChange(of: challengeCode) { _ in
                                            
                                            challengeCodeArray = challengeCode.map { String($0) }
                                            
                                            if challengeCodeArray.count < 6 {
                                                if challengeCodeArray.count != 5 {
                                                    let times = 5 - challengeCodeArray.count
                                                    for _ in 1...times {
                                                        challengeCodeArray.append("_")
                                                    }
                                                }
                                            }
                                        }
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                    keyboardFocused = true
                                                }
                                            }
                                }
                                HStack {
                                    ForEach(challengeCodeArray, id: \.self) {
                                        LetterComponent(letter: $0, variant: .input)
                                    }
                                }
                            }.frame(height: 80)
                                .onTapGesture {
                                    keyboardFocused = true
                                }
                            
                            ButtonComponent(style: .primary(isEnabled: true),
                                            text: "enterWithCodeButtonText") {
                                if self._challengeCode.wrappedValue.count < 5 || self._challengeCode.wrappedValue.count > 5 {
                                    self.quickChallengeViewModel.joinChallengeAlertCases = .invalidCode
                                    self.isShowingErrorAlert = true
                                }
                                else {
                                    self.quickChallengeViewModel.enterChallenge(by: self.challengeCode)
                                        .sink(receiveCompletion: { completion in
                                            switch completion {
                                            case .failure(_):
                                                self.isShowingErrorAlert = true
                                            case .finished:
                                                if self.quickChallengeViewModel.joinChallengeAlertCases != .none {
                                                    self.isShowingErrorAlert = true
                                                }
                                                else {
                                                    self.dismiss()
                                                }
                                                
                                                return
                                            }
                                        }, receiveValue: { _ in () })
                                        .store(in: &subscriptions)
                                }
                            }
                            ButtonComponent(style: .secondary(isEnabled: true),
                                            text: "openScanQRCodeButtonText") {
                                self.isPresentingQRCodeReader = true
                            }.fullScreenCover(isPresented: $isPresentingQRCodeReader) {
                                QRCodeScanScreen(codeReadByCamera: $challengeCode)
                            }.onChange(of: challengeCode) { _ in
                                isPresentingQRCodeReader = false
                            }
                        }
                        .padding(.horizontal, Tokens.Spacing.defaultMargin.value)
                        .padding(.bottom, Tokens.Spacing.xs.value)
                    }
                }
            }
            .alert(self.quickChallengeViewModel.joinChallengeAlertCases.title,
                   isPresented: self.$isShowingErrorAlert,
                   presenting: self.quickChallengeViewModel.joinChallengeAlertCases,
                   actions: { _ in
                Button(action: {
                    self.quickChallengeViewModel.joinChallengeAlertCases = .none
                    self.isShowingErrorAlert = false
                }, label: {
                    Text(self.quickChallengeViewModel.joinChallengeAlertCases.primaryButton)
                })
            }, message: { error in
                switch error {
                case .none:
                    Text(self.quickChallengeViewModel.joinChallengeAlertCases.message)
                case .challengeNotFound:
                    Text(self.quickChallengeViewModel.joinChallengeAlertCases.message)
                case .alreadyJoinedChallenge:
                    Text(self.quickChallengeViewModel.joinChallengeAlertCases.message)
                case .invalidCode:
                    Text(self.quickChallengeViewModel.joinChallengeAlertCases.message)
                case .internalServerError:
                    Text(self.quickChallengeViewModel.joinChallengeAlertCases.message)
                }
            })
            .navigationTitle(LocalizedStringKey("enterWithCodeNavTitle"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        self.dismiss()
                    }, label: {
                        Text("Fechar")
                            .foregroundColor(.white)
                    })
                })
            })
        }
    }
}

struct EnterWithCode_Previews: PreviewProvider {
    static var previews: some View {
        EnterWithCodeView()
    }
}

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
