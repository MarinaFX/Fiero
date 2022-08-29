//
//  ContentView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 14/06/22.
//

import SwiftUI
import UXCamSwiftUI
import UXCam

struct ContentView: View {
    @State private var pushHomeView: Bool = false

    init(){
        UXCam.optIntoSchematicRecordings()
        let config = UXCamSwiftUI.Configuration(appKey: "7jcm86kt1or6528")
        UXCamSwiftUI.start(with: config)
    }
    
    var body: some View {
        if self.pushHomeView {
            withAnimation {
                TabBarView()
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
