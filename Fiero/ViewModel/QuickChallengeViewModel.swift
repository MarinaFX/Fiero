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
    
    enum QCType: CustomStringConvertible {
        case quickest
        case highest
        case bestOf
        
        var description: String {
            switch self {
                case .quickest:
                    return "quickest"
                case .highest:
                    return "highest"
                case .bestOf:
                    return "bestof"
            }
        }
    }
    
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
//            "name" : \(name),
//            "type" : \(challengeType.description),
//            "goal" : \(goal),
//            "goalMeasure" : \(goalMeasure),
//            "userId" : \(userId)
//        }
//        """
        let challengeJson = """
        {
            "name" : "Second Challenge by Combine",
            "type" : "quickest",
            "goal" : 115,
            "goalMeasure" : "unity",
            "userId" : "1c9be140-0504-4e88-9e06-cf167dc06718"
        }
        """
        
        let request = makeHTTPRequest(json: challengeJson, scheme: "http", httpMethod: "POST", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT, authToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjFjOWJlMTQwLTA1MDQtNGU4OC05ZTA2LWNmMTY3ZGMwNjcxOCIsImlhdCI6MTY1ODMwOTA1OCwiZXhwIjoxNjU4MzEwODU4fQ.EHFIUdUgCB6tLA3xHy3Y5NvJ3lg0G6-h_3Q25LBoQ_o")
        
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
