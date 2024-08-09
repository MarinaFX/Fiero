//
//  WinScoreSelectionViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 06/08/24.
//

import Foundation
import Combine
import SwiftUI

enum WinScoreSelectionError: Error {
    case failedToCreateChallenge
    case invalidInput
    case negativeAmount
    case APIError(APIError)
    
    var description: LocalizedStringKey {
        switch self {
            case .failedToCreateChallenge, .APIError(_):
                return "Oops, muito desafiador"
            case .negativeAmount:
                return "negativeAmount"
            case .invalidInput:
                return "invalidInput"
        }
    }
}

class WinScoreSelectionViewModel: ObservableObject {
    
    @Published var createdChallenge: QuickChallenge?
    @Published var isPresentingAlert: Bool = false
    @Published var error: WinScoreSelectionError?
    
    private var service: any CombineAPIService
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(service: any CombineAPIService) {
        self.service = service
    }
    
    @discardableResult
    func createChallenge(name: String, challengeType: QCTypeEnum, goal: String, goalMeasure: String, online: Bool, numberOfTeams: Int, maxTeams: Int) -> AnyPublisher<QuickChallenge?, WinScoreSelectionError> {
        
        self.isPresentingAlert = false
        
        guard let goal = Int(goal) else {
            self.error = .invalidInput
            self.isPresentingAlert = true
            return Just(nil)
                .mapError({ _ in .invalidInput })
                .eraseToAnyPublisher()
        }
        
        if goal <= 0 {
            self.error = .negativeAmount
            self.isPresentingAlert = true
            return Just(nil)
                .mapError({ _ in .negativeAmount })
                .eraseToAnyPublisher()
        }
        
        let body = self.createChallengeJSON(name: name, challengeType: challengeType, goal: goal, goalMeasure: goalMeasure, online: online, numberOfTeams: numberOfTeams, maxTeams: maxTeams)
        
        let operation = self.service.save(QuickChallenge.self, path: .challenge, body: body)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .share()
            
        operation
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        self.isPresentingAlert = false
                        self.error = nil
                        return
                    case .failure(let failure):
                        self.error = .failedToCreateChallenge
                        self.isPresentingAlert = true
                        print("Error in \(#function) :--: \(failure) :--: \(Date.now.ISO8601Format())")
                }
            }, receiveValue: { [weak self] challenge in
                self?.createdChallenge = challenge
                self?.isPresentingAlert = false
            })
            .store(in: &subscriptions)
        
        return operation
            .map({ quickChallenge in
                var challenge: QuickChallenge?
                challenge = quickChallenge
                return challenge
            })
            .mapError({ .APIError($0) })
            .eraseToAnyPublisher()
    }
    
    private func createChallengeJSON(name: String, challengeType: QCTypeEnum, goal: Int, goalMeasure: String, online: Bool, numberOfTeams: Int, maxTeams: Int) -> String {
        return """
        {
            "name" : "\(name)",
            "type" : "\(challengeType.description)",
            "goal" : \(goal),
            "goalMeasure" : "\(goalMeasure)",
            "online" : \(online),
            "numberOfTeams" : \(online ? 1 : numberOfTeams),
            "maxTeams" : \(online ? 9999 : maxTeams)
        }
        """
    }
}
