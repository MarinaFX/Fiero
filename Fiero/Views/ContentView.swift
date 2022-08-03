//
//  ContentView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 14/06/22.
//

import SwiftUI

struct ContentView: View {
    @State private var pushHomeView: Bool = false

    var body: some View {
        if self.pushHomeView {
            withAnimation {
                EmptyChallengesView()
                    .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
            }
        }
        
        if !self.pushHomeView {
            AccountLoginView(pushHomeView: self.$pushHomeView)
                .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .leading)))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
