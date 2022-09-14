//
//  Lottie.swift
//  Fiero
//
//  Created by Marcelo Diefenbach on 31/08/22.
//

import Foundation
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
    typealias UIViewType = UIView
    var fileName: String
    var reverse: Bool
    var loop: Bool
    var aspectFill: Bool = false
    
    var secondAnimation: String?
    var loopSecond: Bool?
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = AnimationView()
        let animation = Animation.named(fileName)
        animationView.animation = animation
        if aspectFill {
            animationView.contentMode = .scaleAspectFill
        } else {
            animationView.contentMode = .scaleAspectFit
        }
        
        if loop {
            animationView.loopMode = .loop
        } else {
            animationView.loopMode = .playOnce
        }
        if reverse {
            animationView.loopMode = .autoReverse
        }
        animationView.backgroundBehavior = .pauseAndRestore
        
        if let secondAnimation = secondAnimation {
            let secondAnimation = Animation.named(secondAnimation)
            animationView.play(fromProgress: 0, toProgress: 1, loopMode: LottieLoopMode.playOnce, completion: { finished in
                if finished {
                    animationView.animation = secondAnimation
                    guard let loopSecond = loopSecond else {
                        animationView.loopMode = .playOnce
                        return
                    }
                    
                    if loopSecond { animationView.loopMode = .loop }

                    animationView.play()
                }
            })
        }
        else {
            animationView.play()
        }
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
