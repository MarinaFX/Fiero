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
    @Published var didUpdateChallenges: Bool = false
    
    private let BASE_URL: String = "localhost"
    //    private let BASE_URL: String = "ec2-18-229-132-19.sa-east-1.compute.amazonaws.com"
    private let ENDPOINT_CREATE_CHALLENGE: String = "/quickChallenge/create"
    private let ENDPOINT_GET_CHALLENGES: String = "/quickChallenge/createdByMe"
    private let ENDPOINT_DELETE_CHALLENGES: String = "/quickChallenge"

    private(set) var client: HTTPClient
    private(set) var keyValueStorage: KeyValueStorage
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    //MARK: - Init
    init (client: HTTPClient = URLSession.shared, keyValueStorage: KeyValueStorage = UserDefaults.standard) {
        self.client = client
        self.serverResponse = .unknown
        self.keyValueStorage = keyValueStorage
    }
    
    //MARK: - Create Quick Challenge
    func createQuickChallenge(name: String, challengeType: QCType, goal: Int, goalMeasure: String, online: Bool = false, numberOfTeams: Int, maxTeams: Int) {
        self.didUpdateChallenges = false
        self.serverResponse = .unknown
        
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
        
        let userToken = keyValueStorage.string(forKey: "AuthToken")!
        
        let request = makePOSTRequest(json: challengeJson, scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_CREATE_CHALLENGE, authToken: userToken)
        
        self.client.perform(for: request)
            .decodeHTTPResponse(type: QuickChallengePOSTResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Publisher failed with: \(error)")
                case .finished:
                    print("Publisher received sucessfully")
                }
            }, receiveValue: { [weak self] urlResponse in
                guard let response = urlResponse.item else {
                    self?.serverResponse.statusCode = urlResponse.statusCode
                    print("error response status code: \(urlResponse.statusCode)")
                    return
                }
                
                self?.serverResponse.statusCode = urlResponse.statusCode
                self?.challengesList.append(contentsOf: response.quickChallenge)
                print("successful response: \(response)")
                print("response status code: \(urlResponse.statusCode)")

            })
            .store(in: &cancellables)
    }
    
    //MARK: - Get User Challenges
    func getUserChallenges() {
        self.didUpdateChallenges = false
        self.serverResponse = .unknown
        let userToken = keyValueStorage.string(forKey: "AuthToken")!
        
        let request = makeGETRequest(scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_GET_CHALLENGES, authToken: userToken)
        
        self.client.perform(for: request)
            .decodeHTTPResponse(type: QuickChallengeGETResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Publisher failed with: \(error)")
                case .finished:
                    print("Publisher received sucessfully")
                }
            }, receiveValue: { [weak self] urlResponse in
                if let response = urlResponse.item {
                    self?.challengesList = response.quickChallenges
                    self?.didUpdateChallenges = true
                }
                
                self?.serverResponse.statusCode = urlResponse.statusCode
                print("error while fetching challenges: \(String(describing: self?.serverResponse.statusCode))")
            })
            .store(in: &cancellables)
    }
    
    //MARK: - Get User Challenges
    func deleteChallenge(by id: String) {
        self.didUpdateChallenges = false
        self.serverResponse = .unknown
        let userToken = self.keyValueStorage.string(forKey: "AuthToken")!
        
        let request = makeDELETERequest(param: id, scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_DELETE_CHALLENGES, authToken: userToken)
        
        self.client.perform(for: request)
            .decodeHTTPResponse(type: [String:String].self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { result in
                switch result {
                    case .failure(let error):
                        print("Failed to create publisher: \(error)")
                    case .finished:
                        print("Successfully created publisher")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    print(self?.serverResponse.statusCode)
                    return
                }
                self?.challengesList.removeAll(where: { $0.id == id} )
                print(response)
            })
            .store(in: &cancellables)
    }
}
