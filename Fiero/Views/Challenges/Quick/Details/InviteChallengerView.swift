//
//  InviteChallengerView.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/10/22.
//

import SwiftUI

struct InviteChallengerView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var inviteCode: String
    @State var inviteCodeArray: Array = ["a", "a", "a", "a", "a"]
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var body: some View {
        NavigationView {
            ZStack {
                Tokens.Colors.Background.dark.value
                    .edgesIgnoringSafeArea(.all)
                
                VStack (spacing: Tokens.Spacing.xs.value){
                    Spacer()
                    
                    Text(LocalizedStringKey("inviteTitle"))
                        .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                    
                    Text(LocalizedStringKey("inviteDescription"))
                        .font(Tokens.FontStyle.callout.font())
                        .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.height * 0.3)
                    VStack (spacing: Tokens.Spacing.xxs.value){
                        Image(uiImage: generateQRCode(from: "\(inviteCode)"))
                            .interpolation(.none)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.height*0.19, height: UIScreen.main.bounds.height*0.19)
                            .padding(Tokens.Spacing.xxxs.value)
                            .background(Tokens.Colors.Neutral.High.pure.value)
                    }.cornerRadius(Tokens.Border.BorderRadius.normal.value)
                    
                    HStack {
                        ForEach(inviteCodeArray, id: \.self) {
                            LetterComponent(letter: $0)
                        }
                    }.frame(height: 80)
                    
                    Button {
                        copyInviteCode()
                    } label: {
                        Text(LocalizedStringKey("inviteButtonCodeText"))
                            .font(Tokens.FontStyle.caption.font())
                            .foregroundColor(Tokens.Colors.Neutral.Low.pure.value)
                            .padding(.vertical, Tokens.Spacing.nano.value)
                            .padding(.horizontal, Tokens.Spacing.xxxs.value)
                            .background(Tokens.Colors.Neutral.High.pure.value)
                            .cornerRadius(Tokens.Border.BorderRadius.normal.value)
                    }
                    
                    Spacer()
                    
                    ButtonComponent(style: .black(isEnabled: true), text: "inviteButtonBackToDetails") {
                        self.dismiss()
                    }
                    .padding(.bottom, Tokens.Spacing.md.value)
                }
                .padding(.horizontal, Tokens.Spacing.xl.value)
            }
            .navigationTitle(LocalizedStringKey("inviteNavTitle"))
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
        .onAppear() {
            inviteCodeArray = inviteCode.map { String($0) }
            print(inviteCodeArray[0])
        }
    }
    
    func copyInviteCode() {
        UIPasteboard.general.string = self.inviteCode
    }
    
    //MARK: - This code transform string in QR Code Image
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct InviteChallengerView_Previews: PreviewProvider {
    static var previews: some View {
        InviteChallengerView(inviteCode: "HD1G5")
    }
}
