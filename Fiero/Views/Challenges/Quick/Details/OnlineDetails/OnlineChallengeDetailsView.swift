//
//  OnlineChallengeDetailsView.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 18/10/22.
//

import SwiftUI
import Combine

struct OnlineChallengeDetailsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var quickChallengeViewModel: QuickChallengeViewModel
    
    @Binding var quickChallenge: QuickChallenge
    
    @State private var subscriptions: Set<AnyCancellable> = []
    @State private var isPresentingParticipantsList: Bool = false
    @State private var isPresentingInvite: Bool = false
    @State private var isPresentingDeleteAlert: Bool = false
    @State private var isPresentingExitAlert: Bool = false
    @State private var isPresetingOngoingView: Bool = false
    @State private var isPresentingAlertError: Bool = false
    
    var body: some View {
        let isOwner = UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) == quickChallenge.ownerId
        NavigationView {
            if(isOwner) {
                //if isOwner (toolbar with if is only available at ios 16+)
                ZStack {
                    Color("background").ignoresSafeArea()
                    ScrollView (showsIndicators: false) {
                        VStack {
                            Image("OnlineDetails")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, smallSpacing)
                                .padding(.bottom, extraSmallSpacing)
                                .padding(.trailing, smallSpacing)
                            //MARK: - Info Component
                            VStack {
                                VStack(alignment: .center, spacing: extraExtraSmallSpacing) {
                                    VStack(alignment: .center, spacing: nanoSpacing) {
                                        Text("Desafio de quantidade")
                                            .font(descriptionFont)
                                            .foregroundColor(foregroundColor)
                                            .padding(.top, extraSmallSpacing)
                                        
                                        Text(quickChallenge.name)
                                            .font(largeTitleFont)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(foregroundColor)
                                            .padding(.horizontal, nanoSpacing)
                                    }
                                    
                                    VStack(alignment: .center, spacing: nanoSpacing) {
                                        Text("Objetivo")
                                            .font(descriptionFont)
                                            .foregroundColor(foregroundColor)
                                        
                                        Text("\(quickChallenge.goal) points")
                                            .font(largeTitleFont)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(foregroundColor)
                                            .padding(.horizontal, nanoSpacing)
                                    }
                                    VStack(alignment: .center, spacing: nanoSpacing) {
                                        Text("Tipo")
                                            .font(descriptionFont)
                                            .foregroundColor(foregroundColor)
                                        
                                        Text("Online")
                                            .font(largeTitleFont)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(foregroundColor)
                                            .padding(.bottom, extraSmallSpacing)
                                            .padding(.horizontal, nanoSpacing)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .overlay(
                                    RoundedRectangle(cornerRadius: borderSmall)
                                        .stroke(foregroundColor, lineWidth: 2)
                                )
                            }
                            
                            
                            
                            //MARK: - Invite Participants
                            HStack {
                                Button {
                                    isPresentingInvite = true
                                } label: {
                                    Text("Convidar Participante")
                                        .font(descriptionFontBold)
                                        .padding(.leading, 16)
                                    Image(systemName: "square.and.arrow.up")
                                        .font(descriptionFontBold)
                                        .padding(.trailing, 16)
                                }
                            }
                            .sheet(isPresented: $isPresentingInvite, content: {
                                InviteChallengerView(inviteCode: quickChallenge.invitationCode ?? "")
                            })
                            .foregroundColor(foregroundColor)
                            .background(.clear)
                            .padding(.horizontal, defaultMarginSpacing)
                            .padding(.top, extraSmallSpacing)
                            .padding(.bottom, extraExtraSmallSpacing)
                            
                            
                            //MARK: - List of Participants
                            HStack {
                                Button {
                                    isPresentingParticipantsList.toggle()
                                } label: {
                                    Text("Participantes")
                                        .padding(.leading, 16)
                                    Spacer()
                                    Text("Ver todos")
                                    Image(systemName: "chevron.right")
                                        .padding(.trailing, 16)
                                }
                            }
                            .foregroundColor(foregroundColor)
                            .frame(height: 44)
                            .background(Tokens.Colors.Neutral.Low.dark.value)
                            .cornerRadius(borderSmall)
                            .padding(.horizontal, defaultMarginSpacing)
                            
                            NavigationLink("", destination: ParticipantsList(quickChallenge: $quickChallenge), isActive: self.$isPresentingParticipantsList).hidden()
                            
                            NavigationLink("", destination: OnlineOngoingChallengeView(quickChallenge: self.$quickChallenge), isActive: self.$isPresetingOngoingView).hidden()
                            
                            ButtonComponent(style: .secondary(isEnabled: true), text: quickChallenge.alreadyBegin ? "Continuar desafio" : "Começar desafio!", action: {
                                self.quickChallengeViewModel.beginChallenge(challengeId: self.quickChallenge.id, alreadyBegin: true)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                            case .failure(_):
                                                self.isPresentingAlertError = true
                                            case .finished:
                                                self.isPresetingOngoingView.toggle()
                                        }
                                    }, receiveValue: { _ in () })
                                    .store(in: &subscriptions)
                            })
                            .padding(.horizontal, defaultMarginSpacing)
                            .padding(.top, extraSmallSpacing)
                            .padding(.bottom, extraExtraSmallSpacing)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button {
                            self.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("backButtonText")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.isPresentingDeleteAlert = true
                            self.quickChallengeViewModel.detailsAlertCases = .deleteChallenge
                            HapticsController.shared.activateHaptics(hapticsfeedback: .heavy)
                        }, label: {
                            Image(systemName: "trash.fill")
                                .font(descriptionFontBold)
                                .foregroundColor(foregroundColor)
                        })
                    }
                    
                }
                .alert(isPresented: self.$isPresentingDeleteAlert, content: {
                    switch quickChallengeViewModel.detailsAlertCases {
                        case .deleteChallenge:
                            return Alert(title: Text(DetailsAlertCases.deleteChallenge.title),
                                         message: Text(DetailsAlertCases.deleteChallenge.message),
                                         primaryButton: .cancel(Text(DetailsAlertCases.deleteChallenge.primaryButtonText), action: {
                                self.isPresentingDeleteAlert = false
                            }), secondaryButton: .destructive(Text("Apagar desafio"), action: {
                                self.quickChallengeViewModel.deleteChallenge(by: quickChallenge.id)
                                    .sink { completion in
                                        switch completion {
                                            case .finished:
                                                self.dismiss()
                                            case .failure(let error):
                                                print(error)
                                                self.quickChallengeViewModel.detailsAlertCases = .failureDeletingChallenge
                                                self.isPresentingDeleteAlert.toggle()
                                        }
                                    } receiveValue: { _ in }
                                    .store(in: &subscriptions)
                            }))
                        case .failureDeletingChallenge:
                            return Alert(title: Text("Failed to delete challenge"), message: Text("Something went wrong and we couldn't delete your challenge."), dismissButton: .cancel(Text("ok"), action: {
                                self.isPresentingDeleteAlert = false
                                self.dismiss()
                            }))
                        default:
                            return Alert(title: Text("Sorry"), message: Text("Something went wrong."), dismissButton: .cancel(Text("ok"), action: {
                                self.isPresentingDeleteAlert = false
                                self.dismiss()
                            }))
                    }
                })
            }
            else {
                //if is not owner (toolbar with if is only available at ios 16+)
                ZStack {
                    Color("background").ignoresSafeArea()
                    ScrollView (showsIndicators: false) {
                        VStack {
                            Image("OnlineDetails")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, smallSpacing)
                                .padding(.bottom, extraSmallSpacing)
                                .padding(.trailing, smallSpacing)
                            //MARK: - Info Component
                            VStack {
                                VStack(alignment: .center, spacing: extraExtraSmallSpacing) {
                                    VStack(alignment: .center, spacing: nanoSpacing) {
                                        Text("Desafio de quantidade")
                                            .font(descriptionFont)
                                            .foregroundColor(foregroundColor)
                                            .padding(.top, extraSmallSpacing)
                                        
                                        Text(quickChallenge.name)
                                            .font(largeTitleFont)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(foregroundColor)
                                            .padding(.horizontal, nanoSpacing)
                                    }
                                    
                                    VStack(alignment: .center, spacing: nanoSpacing) {
                                        Text("Objetivo")
                                            .font(descriptionFont)
                                            .foregroundColor(foregroundColor)
                                        
                                        Text("\(quickChallenge.goal) points")
                                            .font(largeTitleFont)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(foregroundColor)
                                            .padding(.horizontal, nanoSpacing)
                                    }
                                    VStack(alignment: .center, spacing: nanoSpacing) {
                                        Text("Tipo")
                                            .font(descriptionFont)
                                            .foregroundColor(foregroundColor)
                                        
                                        Text("Online")
                                            .font(largeTitleFont)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(foregroundColor)
                                            .padding(.bottom, extraSmallSpacing)
                                            .padding(.horizontal, nanoSpacing)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .overlay(
                                    RoundedRectangle(cornerRadius: borderSmall)
                                        .stroke(foregroundColor, lineWidth: 2)
                                )
                            }
                            
                            //MARK: - Invite Participants
                            HStack {
                                Button {
                                    isPresentingInvite = true
                                } label: {
                                    Text("Convidar Participante")
                                        .font(descriptionFontBold)
                                        .padding(.leading, 16)
                                    Image(systemName: "square.and.arrow.up")
                                        .font(descriptionFontBold)
                                        .padding(.trailing, 16)
                                }
                            }
                            .sheet(isPresented: $isPresentingInvite, content: {
                                InviteChallengerView(inviteCode: quickChallenge.invitationCode ?? "")
                            })
                            .foregroundColor(foregroundColor)
                            .background(.clear)
                            .padding(.horizontal, defaultMarginSpacing)
                            .padding(.top, extraSmallSpacing)
                            .padding(.bottom, extraExtraSmallSpacing)
                            
                            
                            //MARK: - List of Participants
                            HStack {
                                Button {
                                    isPresentingParticipantsList.toggle()
                                } label: {
                                    Text("Participantes")
                                        .padding(.leading, 16)
                                    Spacer()
                                    Text("Ver todos")
                                    Image(systemName: "chevron.right")
                                        .padding(.trailing, 16)
                                }
                            }
                            .foregroundColor(foregroundColor)
                            .frame(height: 44)
                            .background(Tokens.Colors.Neutral.Low.dark.value)
                            .cornerRadius(borderSmall)
                            .padding(.horizontal, defaultMarginSpacing)
                            
                            NavigationLink("", destination: ParticipantsList(quickChallenge: $quickChallenge), isActive: self.$isPresentingParticipantsList).hidden()
                            
                            NavigationLink("", destination: OnlineOngoingChallengeView(quickChallenge: self.$quickChallenge), isActive: self.$isPresetingOngoingView).hidden()
                            
                            if self.quickChallenge.alreadyBegin {
                                ButtonComponent(style: .secondary(isEnabled: true), text: "Continuar desafio", action: {
                                    self.isPresetingOngoingView.toggle()
                                })
                                .padding(.horizontal, defaultMarginSpacing)
                                .padding(.top, extraSmallSpacing)
                                .padding(.bottom, extraExtraSmallSpacing)
                            }
                            else {
                                Text("Hmmm, parece que o dono do desafio \nestá com medo de perder para você \ne não iniciou esse desafio")
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .alert(isPresented: self.$isPresentingExitAlert, content: {
                    switch self.quickChallengeViewModel.exitChallengeAlertCases {
                        case .exitChallenge:
                            return Alert(title: Text(ExitChallengeAlertCasesEnum.exitChallenge.title),
                                         message: Text(ExitChallengeAlertCasesEnum.exitChallenge.message),
                                         primaryButton: .cancel(Text(ExitChallengeAlertCasesEnum.exitChallenge.secondaryButton), action: {
                                self.isPresentingExitAlert = false
                            }), secondaryButton: .destructive(Text(ExitChallengeAlertCasesEnum.exitChallenge.primaryButton), action: {
                                self.quickChallengeViewModel.exitChallenge(by: self.quickChallenge.id)
                                    .sink(receiveCompletion: { completion in
                                        switch completion {
                                            case .finished:
                                                self.dismiss()
                                            case .failure(let error):
                                                print(error)
                                                self.quickChallengeViewModel.exitChallengeAlertCases = .errorWhenTryingToLeaveChallenge
                                                self.isPresentingExitAlert.toggle()
                                        }
                                    }, receiveValue: { _ in () })
                                    .store(in: &subscriptions)
                            }))
                        case .userOrChallengeNotFound:
                            return Alert(title: Text(ExitChallengeAlertCasesEnum.userOrChallengeNotFound.title), message: Text(ExitChallengeAlertCasesEnum.userOrChallengeNotFound.message), dismissButton: .cancel(Text(ExitChallengeAlertCasesEnum.userOrChallengeNotFound.primaryButton), action: {
                                self.isPresentingExitAlert = false
                            }))
                        case .userNotInChallenge:
                            return Alert(title: Text(ExitChallengeAlertCasesEnum.userNotInChallenge.title), message: Text(ExitChallengeAlertCasesEnum.userNotInChallenge.message), dismissButton: .cancel(Text(ExitChallengeAlertCasesEnum.userNotInChallenge.primaryButton), action: {
                                self.isPresentingExitAlert = false
                            }))
                        case .internalServerError:
                            return Alert(title: Text(ExitChallengeAlertCasesEnum.internalServerError.title), message: Text(ExitChallengeAlertCasesEnum.internalServerError.message), dismissButton: .cancel(Text(ExitChallengeAlertCasesEnum.internalServerError.primaryButton), action: {
                                self.isPresentingExitAlert = false
                            }))
                        case .errorWhenTryingToLeaveChallenge:
                            return Alert(title: Text(ExitChallengeAlertCasesEnum.errorWhenTryingToLeaveChallenge.title), message: Text(ExitChallengeAlertCasesEnum.errorWhenTryingToLeaveChallenge.message), dismissButton: .cancel(Text(ExitChallengeAlertCasesEnum.errorWhenTryingToLeaveChallenge.primaryButton), action: {
                                self.isPresentingExitAlert = false
                            }))
                        case .none:
                            return Alert(title: Text("not expected"))
                    }
                })
                
                
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("backButtonText")
                            }
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.isPresentingExitAlert = true
                            self.quickChallengeViewModel.exitChallengeAlertCases = .exitChallenge
                            HapticsController.shared.activateHaptics(hapticsfeedback: .heavy)
                        }, label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(descriptionFontBold)
                                .foregroundColor(foregroundColor)
                        })
                    }
                }
            }
        }
        .accentColor(foregroundColor)
        
    }
    //MARK: Color
    var backgroundColor: Color {
        return Tokens.Colors.Background.dark.value
    }
    var foregroundColor: Color {
        return Tokens.Colors.Neutral.High.pure.value
    }
    
    //MARK: Spacing
    var quarckSpacing: CGFloat {
        return Tokens.Spacing.quarck.value
    }
    var nanoSpacing: CGFloat {
        return Tokens.Spacing.nano.value
    }
    var smallSpacing: CGFloat {
        return Tokens.Spacing.sm.value
    }
    var extraExtraSmallSpacing: CGFloat {
        return Tokens.Spacing.xxxs.value
    }
    var extraSmallSpacing: CGFloat {
        return Tokens.Spacing.xs.value
    }
    var defaultMarginSpacing: CGFloat {
        return Tokens.Spacing.defaultMargin.value
    }
    
    //MARK: Border
    var borderSmall: CGFloat {
        return Tokens.Border.BorderRadius.small.value
    }
    
    //MARK: Font
    var descriptionFont: Font {
        return Tokens.FontStyle.callout.font()
    }
    var descriptionFontBold: Font {
        return Tokens.FontStyle.callout.font(weigth: .bold)
    }
    var largeTitleFont: Font {
        return Tokens.FontStyle.largeTitle.font(weigth: .heavy)
    }
}

struct OnlineChallengeDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        OnlineChallengeDetailsView(quickChallenge: .constant(QuickChallenge(id: "", name: "Girls Challenge part 1", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: true, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [Team(id: "id", name: "Naty", quickChallengeId: "id", createdAt: "", updatedAt: ""), Team(id: "id2", name: "player2", quickChallengeId: "id", createdAt: "", updatedAt: "")], owner: User(email: "a@naty.pq", name: "naty"))))
            .environmentObject(QuickChallengeViewModel())
    }
}
