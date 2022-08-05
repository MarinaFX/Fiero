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
    
    //private let BASE_URL: String = "ec2-18-229-132-19.sa-east-1.compute.amazonaws.com"
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
    func createQuickChallenge(name: String, challengeType: QCType, goal: Int, goalMeasure: String, online: Bool = false, numberOfTeams: Int, maxTeams: Int) {
        let challengeJson = """
        {
            "name" : "\(name)",
            "type" : "\(challengeType.description)",
            "goal" : \(goal),
            "goalMeasure" : "\(goalMeasure)",
            "online" : \(online),
            "numberOfTeams" : \(numberOfTeams),
            "maxTeams" : \(maxTeams)
        }
        """
        print(challengeJson)
        
        let userDefaults = UserDefaults.standard
        let userToken = userDefaults.string(forKey: "AuthToken")!
        
        let request = makePOSTRequest(json: challengeJson, scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT, authToken: userToken)
        
        self.client.perform(for: request)
            .decodeHTTPResponse(type: QuickChallengeResponse.self, decoder: JSONDecoder())
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
                guard let response = urlResponse.item else {
                    self?.serverResponse.statusCode = urlResponse.statusCode
                    print(urlResponse.statusCode)
                    return
                }
                print(response)
            })
            .store(in: &cancellables)
    }
}
