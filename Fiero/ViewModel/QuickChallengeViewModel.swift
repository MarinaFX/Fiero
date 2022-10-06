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
    @Published var newlyCreatedChallenge: QuickChallenge
    @Published var detailsAlertCases: DetailsAlertCases = .deleteChallenge

    private(set) var client: HTTPClient
    private(set) var keyValueStorage: KeyValueStorage
    private(set) var authTokenService: AuthTokenService
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    var sortedList: [QuickChallenge] {
        self.challengesList.sorted(by: { $0.updatedAt > $1.updatedAt })
    }
    
    //MARK: - Init
    init (client: HTTPClient = URLSession.shared,
          keyValueStorage: KeyValueStorage = UserDefaults.standard,
          authTokenService: AuthTokenService = AuthTokenServiceImpl()) {
        self.client = client
        self.serverResponse = .unknown
        self.keyValueStorage = keyValueStorage
        self.authTokenService = authTokenService
        self.newlyCreatedChallenge = QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))
    }
    
    //MARK: - Create Quick Challenge
    func createQuickChallenge(name: String, challengeType: QCType, goal: Int, goalMeasure: String, online: Bool = false, numberOfTeams: Int, maxTeams: Int) -> AnyPublisher<Void, Error> {
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
        
        let operation = self.authTokenService.getAuthToken()
            .flatMap({
                let request = makePOSTRequest(json: challengeJson, scheme: "http", port: 3333,
                                                     baseURL: FieroAPIEnum.BASE_URL.description,
                                                     endPoint: QuickChallengeEndpointEnum.CREATE_CHALLENGE.description,
                                                     authToken: $0)

                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: QuickChallengePOSTResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
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
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    //MARK: - Get User Challenges
    @discardableResult
    func getUserChallenges() -> AnyPublisher<Void, Error> {
        self.serverResponse = .unknown
        
        let operation = self.authTokenService.getAuthToken()
            .flatMap({
                let request = makeGETRequest(scheme: "http", port: 3333,
                                             baseURL: FieroAPIEnum.BASE_URL.description,
                                             endPoint: QuickChallengeEndpointEnum.GET_CHALLENGES.description,
                                             authToken: $0)
                return self.client.perform(for: request)
            })
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
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                let request = makeDELETERequest(param: id, scheme: "http", port: 3333,
                                                baseURL: FieroAPIEnum.BASE_URL.description,
                                                endPoint: QuickChallengeEndpointEnum.DELETE_CHALLENGES.description,
                                                authToken: authToken)
                return self.client.perform(for: request)
            })
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
                guard let _ = rawURLResponse.item else {
                    print("error while trying to delete challenge: \(self?.serverResponse.statusCode as Any)")
                    return
                }
                self?.challengesList.removeAll(where: { $0.id == id} )
            })
            .store(in: &cancellables)
        
        return operation
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Begin Challenge Update
    func beginChallenge(challengeId: String, alreadyBegin: Bool) -> AnyPublisher<Void, Error> {
        let json = """
        {
            "alreadyBegin" : \(alreadyBegin)
        }
        """
        
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                let request = makePATCHRequest(json: json, param: challengeId,
                                               variableToBePatched: VariablesToBePatchedQuickChallenge.alreadyBegin.description,
                                               scheme: "http",
                                               port: 3333,
                                               baseURL: FieroAPIEnum.BASE_URL.description,
                                               endPoint: QuickChallengeEndpointEnum.PATCH_CHALLENGES_BEGIN.description,
                                               authToken: authToken)
                
                return self.client.perform(for: request)
            })
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
                print("successfully began challenge: \(rawURLResponse.statusCode)")
                
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
        guard let userToken = keyValueStorage.string(forKey: "AuthToken") else {
            print("NO USER TOKEN FOUND!")
            return
        }
        
        let json = """
        {
            "finished" : \(finished)
        }
        """
        print(json)
        let request = makePATCHRequest(json: json, param: challengeId,
                                       variableToBePatched: VariablesToBePatchedQuickChallenge.finished.description,
                                       scheme: "http", port: 3333,
                                       baseURL: FieroAPIEnum.BASE_URL.description,
                                       endPoint: QuickChallengeEndpointEnum.PATCH_CHALLENGES_FINISHED.description,
                                       authToken: userToken)
        
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
    
    //MARK: - Patch Score
    @discardableResult
    func patchScore(challengeId: String, teamId: String, memberId: String, score: Double) -> AnyPublisher<Void, Error> {
        self.serverResponse = .unknown
        guard let userToken = self.keyValueStorage.string(forKey: "AuthToken") else {
            print("nao achou token")
            return Empty(completeImmediately: true, outputType: Void.self, failureType: Error.self)
                .eraseToAnyPublisher()
        }
        
        let json = """
        {
            "score" : \(score)
        }
        """
        print(json)
        
        let request = makePATCHRequestScore(json: json, challengeId: challengeId,
                                            teamId: teamId, memberId: memberId,
                                            variableToBePatched: VariablesToBePatchedQuickChallenge.score.description,
                                            scheme: "http",
                                            port: 3333,
                                            baseURL: FieroAPIEnum.BASE_URL.description,
                                            endPoint: QuickChallengeEndpointEnum.PATCH_CHALLENGES_SCORE.description,
                                            authToken: userToken)
        
        let operation = self.client.perform(for: request)
            .decodeHTTPResponse(type: QuickChallengePATCHScoreResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation
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
        
        return operation
            .map({ _ in ()})
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    func showingAlertToFalse() {
        showingAlert = false
    }
    
    func showingAlertToTrue() {
        showingAlert = true
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
