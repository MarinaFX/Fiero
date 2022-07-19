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
    
    init(){
        UXCam.optIntoSchematicRecordings()
        let config = UXCamSwiftUI.Configuration(appKey: "7jcm86kt1or6528")
        UXCamSwiftUI.start(with: config)
    }
    var body: some View {
        AccountLoginView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
