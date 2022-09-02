//
//  WinScreen.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 02/09/22.
//

import SwiftUI

struct WinScreen: View {
    var body: some View {
        LottieView(fileName: "winAnimation", reverse: false, loop: true).ignoresSafeArea()
    }
}

struct WinScreen_Previews: PreviewProvider {
    static var previews: some View {
        WinScreen()
    }
}
