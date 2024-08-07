//
//  QRCodeScanView.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 01/11/22.
//

import Foundation
import SwiftUI

struct QRCodeScanView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var codeReadByCamera: String
    @State var isPresentManualInputCode: Bool = false

    var body: some View {
        ZStack {
            QRCodeReader(text: $codeReadByCamera).ignoresSafeArea()
            VStack {
                Text(LocalizedStringKey("titleQRCodeView"))
                    .font(Tokens.FontStyle.largeTitle.font(weigth: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                    .padding(.bottom)
                    .padding(.top, Tokens.Spacing.lg.value)
                Spacer()
            }
            VStack {
                RoundedRectangle(cornerRadius: Tokens.Border.BorderRadius.normal.value)
                    .stroke(Tokens.Colors.Brand.Primary.pure.value, lineWidth: Tokens.Border.BorderWidth.heavy.value)
                    .frame(width: 250, height: 250)
            }
            VStack {
                Spacer()
                ButtonComponent(style: .secondary(isEnabled: true),
                                text: "backButtonQRCodeView",
                                action: {
                    presentationMode.wrappedValue.dismiss()
                }).padding(.bottom, Tokens.Spacing.sm.value)
            }.padding(.horizontal, Tokens.Spacing.defaultMargin.value)
        }
    }
}

struct QRCodeScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeScanView(codeReadByCamera: .constant(""))
    }
}

struct QRCodeReader: UIViewControllerRepresentable {
    
    @Binding var text: String
    
    typealias UIViewControllerType = ScanViewController

    func makeUIViewController(context: Context) -> ScanViewController {
        let vc = ScanViewController(text: _text)
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

    }
}
