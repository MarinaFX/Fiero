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
    @Published var challengesList: [QuickChallenge] = []
    @Published var serverResponse: ServerResponse
    
    private let BASE_URL: String = "localhost"
    //    private let BASE_URL: String = "ec2-18-229-132-19.sa-east-1.compute.amazonaws.com"
    private let ENDPOINT_CREATE_CHALLENGE: String = "/quickChallenge/create"
    private let ENDPOINT_GET_CHALLENGES: String = "/quickChallenge/createdByMe"
    
    private(set) var client: HTTPClient
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Init
    init (client: HTTPClient = URLSession.shared) {
        self.client = client
        self.serverResponse = .unknown
    }
    
    //MARK: - Create Quick Challenge
    func createQuickChallenge(name: String, challengeType: QCType, goal: Int, goalMeasure: String) {
        
        let challengeJson = """
        {
            "name" : "\(name)",
            "type" : "\(challengeType.description)",
            "goal" : \(goal),
            "goalMeasure" : "\(goalMeasure)",
            "online" : false,
            "numberOfTeams" : 2,
            "maxTeams" : 2
        }
        """
        print(challengeJson)
        
        let userDefaults = UserDefaults.standard
        let userToken = userDefaults.string(forKey: "AuthToken")!
        
        let request = makePOSTRequest(json: challengeJson, scheme: "http", httpMethod: "POST", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_CREATE_CHALLENGE, authToken: userToken)
        
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
    
    //MARK: - Get User Challenges
    func getUserChallenges() {
        let userDefaults = UserDefaults.standard
        let userToken = userDefaults.string(forKey: "AuthToken")!
        
        let request = makeGETRequest(scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_GET_CHALLENGES, authToken: userToken)
        
        self.client.perform(for: request)
            .decodeHTTPResponse(type: QuickChallengeResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("completion failed with: \(error)")
                case .finished:
                    print("finished successfully")
                }
            }, receiveValue: { [weak self] urlResponse in
                if let response = urlResponse.item {
                    self?.challengesList = response.quickChallenges
                }
                
                self?.serverResponse.statusCode = urlResponse.statusCode
                print("fetch user challenges status code: \(self?.serverResponse.statusCode)")
            })
            .store(in: &cancellables)
        
    }
}
