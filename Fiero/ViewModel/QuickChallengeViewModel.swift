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
    @Published var showingAlert = false
    @Published var didUpdateChallenges: Bool = false
    @Published var newlyCreatedChallenge: QuickChallenge
    @Published var detailsAlertCases: DetailsAlertCases = .deleteChallenge
    
    private let BASE_URL: String = "localhost"
    //private let BASE_URL: String = "10.41.48.196"
    //    private let BASE_URL: String = "ec2-18-229-132-19.sa-east-1.compute.amazonaws.com"
    private let ENDPOINT_CREATE_CHALLENGE: String = "/quickChallenge/create"
    private let ENDPOINT_GET_CHALLENGES: String = "/quickChallenge/createdByMe"
    private let ENDPOINT_DELETE_CHALLENGES: String = "/quickChallenge"
    private let ENDPOINT_PATCH_CHALLENGES_BEGIN: String = "/quickChallenge"
    private let ENDPOINT_PATCH_CHALLENGES_FINISHED: String = "/quickChallenge"
    private let ENDPOINT_PATCH_CHALLENGES_SCORE: String = "/quickChallenge"

    private(set) var client: HTTPClient
    private(set) var keyValueStorage: KeyValueStorage
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var sortedList: [QuickChallenge] {
        self.challengesList.sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    //MARK: - Init
    init (client: HTTPClient = URLSession.shared, keyValueStorage: KeyValueStorage = UserDefaults.standard) {
        self.client = client
        self.serverResponse = .unknown
        self.keyValueStorage = keyValueStorage
        self.newlyCreatedChallenge = QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))
    }
    
    //MARK: - Create Quick Challenge
    func createQuickChallenge(name: String, challengeType: QCType, goal: Int, goalMeasure: String, online: Bool = false, numberOfTeams: Int, maxTeams: Int) {
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
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    print("error response status code: \(rawURLResponse.statusCode)")
                    return
                }
                
                self?.serverResponse.statusCode = rawURLResponse.statusCode
                self?.newlyCreatedChallenge = response.quickChallenge[0]
                self?.serverResponse.statusCode = rawURLResponse.statusCode
                self?.challengesList.append(contentsOf: response.quickChallenge)
                print("successful response: \(response)")
                print("response status code: \(rawURLResponse.statusCode)")

            })
            .store(in: &cancellables)
    }
    
    //MARK: - Get User Challenges
    @discardableResult
    func getUserChallenges() -> AnyPublisher<Void, Error> {
        self.serverResponse = .unknown
        let userToken = keyValueStorage.string(forKey: "AuthToken")!
        
        let request = makeGETRequest(scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_GET_CHALLENGES, authToken: userToken)
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: QuickChallengeGETResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.showingAlertToTrue()
                    print("Publisher failed with: \(error)")
                case .finished:
                    print("Publisher received sucessfully")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    print("error while fetching challenges: \(String(describing: self?.serverResponse.statusCode))")
                    return
                }
                self?.challengesList = response.quickChallenges
                self?.serverResponse.statusCode = rawURLResponse.statusCode
                if self?.serverResponse.statusCode == 401 {
                    self?.showingAlertToTrue()
                }
            })
            .store(in: &cancellables)
        
        return operation
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Delete User Challenges
    @discardableResult
    func deleteChallenge(by id: String) -> AnyPublisher<Void, Error> {
        self.serverResponse = .unknown
        let userToken = self.keyValueStorage.string(forKey: "AuthToken")!
        
        let request = makeDELETERequest(param: id, scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_DELETE_CHALLENGES, authToken: userToken)
        
        let operation = self.client.perform(for: request)
            .print("operation")
            .decodeHTTPResponse(type: QuickChallengeDELETEResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
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
                    print(self?.serverResponse.statusCode as Any)
                    return
                }
                self?.challengesList.removeAll(where: { $0.id == id} )
                self?.serverResponse.statusCode = rawURLResponse.statusCode
                print(response)
            })
            .store(in: &cancellables)
        
        return operation
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Begin Challenge Update
    func beginChallenge(challengeId: String, alreadyBegin: Bool) -> AnyPublisher<Void, Error> {
        self.serverResponse = .unknown
        guard let userToken = self.keyValueStorage.string(forKey: "AuthToken")
        else {
            print("nao achou token")
            return Empty().eraseToAnyPublisher()
        }
        
        let json = """
        {
            "alreadyBegin" : \(alreadyBegin)
        }
        """
        print(json)
        let request = makePATCHRequest(json: json, param: challengeId, variableToBePatched: VariablesToBePatchedQuickChallenge.alreadyBegin.description, scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_PATCH_CHALLENGES_BEGIN, authToken: userToken)
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: QuickChallengePATCHResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
            .sink(receiveCompletion: { result in
                switch result {
                    case .failure(let error):
                        print("Failed to create publisher: \(error)")
                    case .finished:
                        print("Successfully created publisher")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item
                else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    return
                }
                if var challengesList = self?.challengesList {
                    for i in 0...challengesList.count-1 {
                        if(challengesList[i].id == challengeId) {
                            challengesList[i] = response.quickChallenge
                        }
                    }
                    self?.challengesList = challengesList
                }
            })
            .store(in: &cancellables)
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    //MARK: - Fisnih Challenge Update
    func finishChallenge(challengeId: String, finished: Bool) {
        self.serverResponse = .unknown
        guard let userToken = self.keyValueStorage.string(forKey: "AuthToken")
        else {
            print("nao achou token")
            return
        }
        
        let json = """
        {
            "finished" : \(finished)
        }
        """
        print(json)
        let request = makePATCHRequest(json: json, param: challengeId, variableToBePatched: VariablesToBePatchedQuickChallenge.finished.description, scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_PATCH_CHALLENGES_FINISHED, authToken: userToken)
        
        self.client.perform(for: request)
            .decodeHTTPResponse(type: QuickChallengePATCHResponse.self, decoder: JSONDecoder())
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
                guard let response = rawURLResponse.item
                else {
                    self?.serverResponse.statusCode = rawURLResponse.statusCode
                    return
                }
                if var challengesList = self?.challengesList {
                    for i in 0...challengesList.count-1 {
                        if(challengesList[i].id == challengeId) {
                            challengesList[i] = response.quickChallenge
                        }
                    }
                    self?.challengesList = challengesList
                }
            })
            .store(in: &cancellables)
    }
    
    func showingAlertToFalse() {
        showingAlert = false
    }
    
    func showingAlertToTrue() {
        showingAlert = true
    }
    //MARK: - Patch Score
    func patchScore(challengeId: String, teamId: String, memberId: String, score: Double) {
        self.serverResponse = .unknown
        guard let userToken = self.keyValueStorage.string(forKey: "AuthToken")
        else {
            print("nao achou token")
            return
        }
        
        let json = """
        {
            "score" : \(score)
        }
        """
        print(json)
        let request = makePATCHRequestScore(json: json, challengeId: challengeId, teamId: teamId, memberId: memberId, variableToBePatched: VariablesToBePatchedQuickChallenge.score.description, scheme: "http", port: 3333, baseURL: BASE_URL, endPoint: ENDPOINT_PATCH_CHALLENGES_SCORE, authToken: userToken)
        
        self.client.perform(for: request)
            .print("after perform")
            .decodeHTTPResponse(type: QuickChallengePATCHScoreResponse.self, decoder: JSONDecoder())
            .print("after decode")
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .flatMap { rawURLResponse -> AnyPublisher<Void, Error> in
                if case .failure = rawURLResponse {
                    return self.getUserChallenges()
                        .eraseToAnyPublisher()
                }
                else {
                    return Empty(completeImmediately: true, outputType: Void.self, failureType: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}

enum VariablesToBePatchedQuickChallenge: CustomStringConvertible {
    case alreadyBegin, finished, score
    
    var description: String {
        switch self {
            case .alreadyBegin:
                return "alreadyBegin"
            case .finished:
                return "finished"
            case .score:
                return "score"
        }
    }
    
}
