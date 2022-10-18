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
    let animationView = AnimationView()
    
    var secondAnimation: String?
    var loopSecond: Bool?
    var isPaused: Bool = false
    @Binding var ended: Bool
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
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
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if isPaused {
            context.coordinator.parent.animationView.stop()
        }
        else {
            context.coordinator.parent.animationView.play { finished in
                if finished {
                    self.ended = true
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: LottieView
        
        init(_ parent: LottieView) {
            self.parent = parent
        }
    }
}
