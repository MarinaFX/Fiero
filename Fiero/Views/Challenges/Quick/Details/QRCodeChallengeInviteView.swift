//
//  QRCodeChallengeInviteView.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 31/10/22.
//

import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeChallengeInviteView: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State var QRCodeString: String
    
    var body: some View {
        VStack (spacing: Tokens.Spacing.xxs.value){
            Image(uiImage: generateQRCode(from: "\(QRCodeString)"))
                .interpolation(.none)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .padding(Tokens.Spacing.nano.value)
                .background(Tokens.Colors.Neutral.High.pure.value)
        }.padding(.vertical, Tokens.Spacing.sm.value)
            .padding(.horizontal, Tokens.Spacing.md.value)
        .background(Tokens.Colors.Highlight.two.value)
        .cornerRadius(Tokens.Border.BorderRadius.normal.value)
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

struct QRCodeInviteChallengeView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeChallengeInviteView(QRCodeString: "ChaljZOxijOIZjxczxlksadasdasdnonjnkjnenge UUID")
    }
}
