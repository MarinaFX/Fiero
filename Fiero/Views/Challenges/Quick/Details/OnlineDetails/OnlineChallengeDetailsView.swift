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
    @State private var isPresentingAlert: Bool = false
    @State private var isPresetingOngoingView: Bool = false
    @State private var isPresentingAlertError: Bool = false
    
    var body: some View {
        let isOwner = UserDefaults.standard.string(forKey: UDKeysEnum.userID.description) == quickChallenge.ownerId
        NavigationView {
            if(isOwner) {
                //if isOwner (toolbar with if is only available at ios 16+)
                ZStack {
                    backgroundColor
                        .edgesIgnoringSafeArea(.all)
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
>>>>>>> dev
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
                            
                            ButtonComponent(style: .secondary(isEnabled: false), text: quickChallenge.alreadyBegin ? "Continuar desafio" : "Começar desafio!", action: { })
                                .padding(.horizontal, defaultMarginSpacing)
                                .padding(.vertical, extraExtraSmallSpacing)
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
                            self.isPresentingAlert = true
                            self.quickChallengeViewModel.detailsAlertCases = .deleteChallenge
                            HapticsController.shared.activateHaptics(hapticsfeedback: .heavy)
                        }, label: {
                            Image(systemName: "trash")
                                .font(descriptionFontBold)
                                .foregroundColor(foregroundColor)
                        })
                    }
                    
                }
                .alert(isPresented: self.$isPresentingAlert, content: {
                    switch quickChallengeViewModel.detailsAlertCases {
                        case .deleteChallenge:
                            return Alert(title: Text(DetailsAlertCases.deleteChallenge.title),
                                         message: Text(DetailsAlertCases.deleteChallenge.message),
                                         primaryButton: .cancel(Text(DetailsAlertCases.deleteChallenge.primaryButtonText), action: {
                                self.isPresentingAlert = false
                            }), secondaryButton: .destructive(Text("Apagar desafio"), action: {
                                self.quickChallengeViewModel.deleteChallenge(by: quickChallenge.id)
                                    .sink { completion in
                                        switch completion {
                                        case .finished:
                                            self.dismiss()
                                        case .failure(let error):
                                            print(error)
                                            self.quickChallengeViewModel.detailsAlertCases = .failureDeletingChallenge
                                            self.isPresentingAlert.toggle()
                                        }
                                    } receiveValue: { _ in }
                                    .store(in: &subscriptions)
                            }))
                        case .failureDeletingChallenge:
                                return Alert(title: Text("Failed to delete challenge"), message: Text("Something went wrong and we couldn't delete your challenge."), dismissButton: .cancel(Text("ok"), action: {
                                    self.isPresentingAlert = false
                                    self.dismiss()
                                }))
                        default:
                            return Alert(title: Text("Sorry"), message: Text("Something went wrong."), dismissButton: .cancel(Text("ok"), action: {
                                self.isPresentingAlert = false
                                self.dismiss()
                            }))
                    }
                })
            }
            else {
                //if is not owner (toolbar with if is only available at ios 16+)
                ZStack {
                    backgroundColor
                        .edgesIgnoringSafeArea(.all)
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
                            
                            ButtonComponent(style: .secondary(isEnabled: false), text: quickChallenge.alreadyBegin ? "Continuar desafio" : "Começar desafio!", action: { })
                                .padding(.horizontal, defaultMarginSpacing)
                                .padding(.vertical, extraExtraSmallSpacing)
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
