//
//  QuickChallengeViewModel.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation
import Combine

//MARK: QuickChallengeViewModel
class QuickChallengeViewModel: ObservableObject {
    //MARK: - Variables Setup
    @Published var serverResponse: ServerResponse
    
    private let BASE_URL: String = "localhost"
    private let ENDPOINT: String = "/quickChallenge/create"
    
    private(set) var client: HTTPClient
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Init
    init (client: HTTPClient = URLSession.shared) {
        self.client = client
        self.serverResponse = .unknown
    }
    
    //MARK: - Create Quick Challenge
    func createQuickChallenge(name: String, challengeType: QCType, goal: Int, goalMeasure: String, userId: String) {
//        let challengeJson = """
//        {
//            "name" : "Third Challenge by Combine with token from user defaults",
//            "type" : "quickest",
//            "goal" : 115,
//            "goalMeasure" : "unity",
//            "userId" : "1c9be140-0504-4e88-9e06-cf167dc06718"
//        }
//        """

        let challengeJson = """
        {
            "name" : \(name),
            "type" : \(challengeType.description),
            "goal" : \(goal),
            "goalMeasure" : \(goalMeasure),
            "userId" : \(userId)
        }
        """
        let userDefaults = UserDefaults.standard
        let userToken = userDefaults.string(forKey: "AuthToken")!
        
        let request = makeHTTPRequest(json: challengeJson, scheme: "http", httpMethod: "POST", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT, authToken: userToken)
        
        self.client.perform(for: request)
            .tryMap({ $0.response })
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        print("completion failed with: \(error.localizedDescription)")
                    case .finished:
                        print("finished successfully")
                }
            }, receiveValue: { [weak self] urlResponse in
                guard let response = urlResponse as? HTTPURLResponse else { return }
                
                print("status code \(response.statusCode)")
                
                self?.serverResponse.statusCode = response.statusCode
            })
            .store(in: &cancellables)
    }
}

/**
 export enum QuickChallengeTypes {
     quickest = 'quickest',
     highest = 'highest',
     bestof = 'bestof'
 }

 export enum QuickChallengeQuickestMeasures {
     unity = 'unity'
 }

 export enum QuickChallengeHighestMeasures {
     minutes = 'minutes',
     seconds = 'seconds'
 }

 export enum QuickChallengeBestofMeasures {
     rounds = 'rounds'
 }

 export enum QuickChallengeBestofGoals {
     five = 5,
     three = 3
 }
 */
