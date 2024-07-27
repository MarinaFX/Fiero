//
//  ScoreList.swift
//  Fiero
//
//  Created by João Gabriel Biazus de Quevedo on 16/11/22.
//

import SwiftUI

struct ScoreList: View {
    @Environment(\.sizeCategory) var sizeCategory
    @State private(set) var style: ScoreListStyle
    
    @State var position: Int
    @State var name: String
    @State var formattedPosition: String = ""
    @Binding var quickChallenge: QuickChallenge
    
    var body: some View {
        if self.sizeCategory.isAccessibilityCategory {
            VStack(alignment: .center, spacing: 10) {
                Text(self.formattedPosition)
                    .font(style.numberFont)
                
                ZStack {
                    VStack(alignment: .center) {
                        Text("\(name)")
                            .font(style.cellFont)
                            .foregroundColor(style.labelColor)
                            .padding(.leading, style.spacing)
                            .lineLimit(5)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        Text(String(format: "%.0f", self.quickChallenge.getRanking()[position-1].getTotalScore()))
                            .font(style.cellFont)
                            .foregroundColor(style.labelColor)
                            .padding(.trailing, style.spacing)
                    }
                    .padding(.vertical)
                }
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(style.backgroundColor)
                .cornerRadius(style.borderRadius)
            }
            .onAppear(perform: {
                let formatter = NumberFormatter()
                formatter.numberStyle = .ordinal
                self.formattedPosition = formatter.string(from: NSNumber(value: UInt(self.position))) ?? ""
            })
        }
        else {
            HStack(spacing: 20) {
                Text(self.formattedPosition)
                    .font(style.numberFont)
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: UIScreen.main.bounds.width*0.12)
                
                ZStack {
                    HStack {
                        Text("\(name)")
                            .font(style.cellFont)
                            .foregroundColor(style.labelColor)
                            .padding(.leading, style.spacing)
                        
                        Spacer()
                        
                        Text(String(format: "%.0f", self.quickChallenge.getRanking()[position-1].getTotalScore()))
                            .font(style.cellFont)
                            .foregroundColor(style.labelColor)
                            .padding(.trailing, style.spacing)
                    }
                    .padding(.vertical)
                }
                .frame(maxWidth: .infinity, maxHeight: 48 , alignment: .leading)
                .background(style.backgroundColor)
                .cornerRadius(style.borderRadius)
            }
            .onAppear(perform: {
                let formatter = NumberFormatter()
                formatter.numberStyle = .ordinal
                self.formattedPosition = formatter.string(from: NSNumber(value: UInt(self.position))) ?? ""
            })
        }
    }
}


struct ScoreList_Previews: PreviewProvider {
    static var previews: some View {
        ScoreList(style: .player, position: 4, name: "Teste", quickChallenge: .constant(QuickChallenge(id: "", name: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))))
    }
}