//
//  CarouselView.swift
//  Fiero
//
//  Created by Marina De Pazzi on 28/07/24.
//

import SwiftUI

struct RoundedRectangleView: View {
    
    var item: CarouselContentItem
    
    var body: some View {
        RoundedRectangle(cornerRadius: 24)
            .overlay(content: {
                VStack {
                    CarouselContentView(item: self.item)
                }
            })
            .frame(width: UIScreen.main.bounds.width * 0.7, height: UIScreen.main.bounds.height * 0.5)
            .foregroundStyle(Tokens.Colors.Neutral.Low.dark.value)
    }
}


struct CarouselView: View {
    
    var items: [CarouselContentItem]
    @State var focusedItem: CarouselContentItem?
    
    @Binding var amountPresentNextScreen: Bool
    @Binding var walkingPresentNextScreen: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer(minLength: 16)
                
                ForEach(self.items, id: \.self) { item in
                    GeometryReader { proxy in
                        let scale = self.getScale(proxy: proxy)
                        
                        RoundedRectangleView(item: item)
                            .scaleEffect(.init(width: scale, height: scale))
                            .animation(.spring(), value: 5)
                            .padding(.vertical)
                    }
                    .onTapGesture(perform: {
                        if item.challengeType != .round {
                            SoundPlayer.playSound(soundName: Sounds.metal, soundExtension: Sounds.metal.soundExtension, soundType: SoundTypes.action)
                            item.challengeType == .amount ? amountPresentNextScreen.toggle() : walkingPresentNextScreen.toggle()
                        }
                    })
                    .frame(width: 240, height: UIScreen.main.bounds.height * 0.42)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 128)
                }
                Spacer(minLength: 48)
            }
            .padding()
        }
    }
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        let midPoint: CGFloat = 115
        
        let viewFrame = proxy.frame(in: CoordinateSpace.global)
        
        var scale: CGFloat = 1.0
        let deltaXAnimationThreshold: CGFloat = 125
        
        let diffFromCenter = abs(midPoint - viewFrame.origin.x - deltaXAnimationThreshold / 2.3)
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 500
        }
        
        return scale
    }
}

struct CarouselContentView: View {
    @State private var ended: Bool = false
    
    var item: CarouselContentItem

    var body: some View {
        VStack {
            ZStack {
                if item.challengeType == .amount {
                    LottieView(fileName: "quantity2", reverse: false, loop: true, aspectFill: false, isPaused: false, ended: $ended).opacity(ended ? 1 : 0)
                    
                    LottieView(fileName: "quantity", reverse: false, loop: false, aspectFill: false, isPaused: false, ended: $ended).opacity(ended ? 0 : 1)
                }
                else {
                    LottieView(fileName: self.item.challengeType.rawValue, reverse: false, loop: true, aspectFill: false, isPaused: false, ended: $ended)
                }
            }
            
            Text(self.item.title)//"amountChallengeTypeTitle"
                .font(Tokens.FontStyle.title.font(weigth: .bold, design: .default))
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .multilineTextAlignment(.center)
                .padding(.bottom, Tokens.Spacing.nano.value)
            
            Text(self.item.subtitle)//"amountChallengeTypeSubtitle"
                .font(Tokens.FontStyle.callout.font())
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .multilineTextAlignment(.center)
                .lineLimit(5)
                .padding(.bottom, Tokens.Spacing.xxxs.value)
                .padding(.horizontal, Tokens.Spacing.quarck.value)
            
            Text("Escolher esse")
                .padding(.horizontal, Tokens.Spacing.xxs.value)
                .padding(.vertical, Tokens.Spacing.nano.value)
                .foregroundColor(Tokens.Colors.Neutral.High.pure.value)
                .background(Tokens.Colors.Highlight.three.value)
                .cornerRadius(Tokens.Border.BorderRadius.normal.value)
                .font(Tokens.FontStyle.callout.font(weigth: .bold, design: .default))
        }
        .padding()
    }
}


struct CarouselContentItem: Identifiable, Hashable {
    enum ChallengeType: String {
        case amount = "quantity"
        case walking = "steps"
        case round = "blockCategory"
    }
    
    var id: UUID = UUID()
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey
    var challengeType: ChallengeType
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView(items: [CarouselContentItem(title: "flemis", subtitle: "flemis", challengeType: .amount), CarouselContentItem(title: "flemis", subtitle: "flemis", challengeType: .walking), CarouselContentItem(title: "flemis", subtitle: "flemis", challengeType: .round)], focusedItem: CarouselContentItem(title: "", subtitle: "", challengeType: .amount), amountPresentNextScreen: .constant(false), walkingPresentNextScreen: .constant(false))
    }
}
