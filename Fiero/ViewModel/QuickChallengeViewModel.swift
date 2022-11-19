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
    @Published var showingAlert = false
    @Published var newlyCreatedChallenge: QuickChallenge
    @Published var detailsAlertCases: DetailsAlertCases = .deleteChallenge
    @Published var joinChallengeAlertCases: JoinChallengeAlertCasesEnum = .challengeNotFound
    @Published var exitChallengeAlertCases: ExitChallengeAlertCasesEnum = .userOrChallengeNotFound
    @Published var editPlayerScoreAlertCases: EditPlayerScoreAlertCasesEnum = .playerNotInChallenge
    @Published var getChallengeAlertCases: GetChallengeAlertCasesEnum = .challengeNotFound
    @Published var removePlayerAlertCases: RemovePlayerAlertCasesEnum = .userOrChallengeNotFound
    
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
        self.keyValueStorage = keyValueStorage
        self.authTokenService = authTokenService
        self.newlyCreatedChallenge = QuickChallenge(id: "", name: "", invitationCode: "", type: "", goal: 0, goalMeasure: "", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 0, createdAt: "", updatedAt: "", teams: [], owner: User(email: "", name: ""))
    }
    
    //MARK: - Create Quick Challenge
    @discardableResult
    func createQuickChallenge(name: String, challengeType: QCTypeEnum, goal: Int, goalMeasure: String, online: Bool = false, numberOfTeams: Int, maxTeams: Int) -> AnyPublisher<Void, Error> {
        let challengeJson = """
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
                    print("Failed to create request to create challenge endpoint: \(error)")
                case .finished:
                    print("Successfully created request to create challenges endpoint")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    print("error response status code: \(rawURLResponse.statusCode)")
                    return
                }
                
                self?.newlyCreatedChallenge = response.quickChallenge[0]
                self?.challengesList.append(contentsOf: response.quickChallenge)
                print("Successfully created challenge: \(rawURLResponse.statusCode)")
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
                    print("Failed to create request to fetch user challenges endpoint: \(error)")
                case .finished:
                    print("Successfully created request to fetch user challenges endpoint")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    print("error fetching challenges: \(rawURLResponse.statusCode)")
                    if rawURLResponse.statusCode == 401 {
                        self?.showingAlertToTrue()
                    }
                    return
                }
                self?.challengesList = response.quickChallenges
                print("Successfully fetched challenges: \(rawURLResponse.statusCode)")
            })
            .store(in: &cancellables)
        
        return operation
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Get Challenge by id
    @discardableResult
    func getChallenge(by id: String) -> AnyPublisher<QuickChallenge, HTTPResponseError> {
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                let request = makeGETRequest(param: id, scheme: "http", port: 3333, baseURL: FieroAPIEnum.BASE_URL.description, endPoint: QuickChallengeEndpointEnum.GET_CHALLENGE.description, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: QuickChallengePATCHResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .tryMap({ rawURLResponse -> QuickChallenge in
                if let quickChallenge = rawURLResponse.item?.quickChallenge {
                    return quickChallenge
                }
                else {
                    throw (HTTPResponseError(rawValue: rawURLResponse.statusCode) ?? .unknown)
                }
            })
            .mapError({ $0 as? HTTPResponseError ?? .unknown })
            .share()
        
        operation
            .sink(receiveCompletion: { [weak self] completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .notFound:
                            self?.getChallengeAlertCases = .challengeNotFound
                        case .internalServerError:
                            self?.getChallengeAlertCases = .internalServerError
                        case .unauthorized:
                            self?.getChallengeAlertCases = .userNotInChallenge
                        default:
                            self?.getChallengeAlertCases = .internalServerError
                    }
                    print("Failed to create request to get challenge endpoint: \(error)")
                case .finished:
                    print("Successfully created request to get challenge endpoint")
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
        
        return operation
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
                        print("Failed to create request to delete challenge endpoint: \(error)")
                    case .finished:
                        print("Successfully created request to delete challenge endpoint")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let _ = rawURLResponse.item else {
                    print("error while trying to delete challenge: \(rawURLResponse.statusCode)")
                    return
                }
                self?.challengesList.removeAll(where: { $0.id == id })
                print("Successfully deleted challenge: \(rawURLResponse.statusCode)")
            })
            .store(in: &cancellables)
        
        return operation
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Enter Challenge by code
    @discardableResult
    func enterChallenge(by code: String) -> AnyPublisher<Void, Error> {
        let json = """
        {
            "invitationCode" : "\(code)"
        }
        """
        
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                let request = makePOSTRequest(json: json, scheme: "http", port: 3333, baseURL: FieroAPIEnum.BASE_URL.description, endPoint: QuickChallengeEndpointEnum.ENTER_CHALLENGE.description, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: QuickChallengePATCHResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation.sink(receiveCompletion: { [weak self] completion in
            switch completion {
                case .failure(let error):
                    print("Failed to create request to join challenge endpoint: \(error)")
                    self?.joinChallengeAlertCases = .internalServerError
                case .finished:
                    print("Successfully created request to join challenges endpoint")
            }
        }, receiveValue: { [weak self] rawURLResponse in
            guard let response = rawURLResponse.item else {
                
                if rawURLResponse.statusCode == 404 {
                    print("error while trying to join challenge: \(rawURLResponse.statusCode)")
                    self?.joinChallengeAlertCases = .challengeNotFound
                    return
                }
                
                if rawURLResponse.statusCode == 409 {
                    print("error while trying to join challenge: \(rawURLResponse.statusCode)")
                    self?.joinChallengeAlertCases = .alreadyJoinedChallenge
                    return
                }
                
                if rawURLResponse.statusCode == 500 {
                    print("error while trying to join challenge: \(rawURLResponse.statusCode)")
                    self?.joinChallengeAlertCases = .internalServerError
                    return
                }
                print("error while trying to join challenge: \(rawURLResponse.statusCode)")
                return
            }
            
            print("Successfully joined challenge: \(rawURLResponse.statusCode)")
            
            self?.joinChallengeAlertCases = .none
            self?.challengesList.append(response.quickChallenge)
        })
        .store(in: &cancellables)
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
    
    //MARK: - Begin Challenge Update
    @discardableResult
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
                        print("Failed to create request to begin challenge endpoint: \(error)")
                    case .finished:
                        print("Successfully created request to begin challenge endpoint")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item else {
                    print("Error while trying to begin challenge: \(rawURLResponse.statusCode)")
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
                print("successfully began challenge: \(rawURLResponse.statusCode)")
            })
            .store(in: &cancellables)
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    //MARK: - Finish Challenge Update
    @discardableResult
    func finishChallenge(challengeId: String, finished: Bool) -> AnyPublisher<Void, Error> {
        let json = """
        {
            "finished" : \(finished)
        }
        """
        
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                
                let request = makePATCHRequest(json: json, param: challengeId,
                                               variableToBePatched: VariablesToBePatchedQuickChallenge.finished.description,
                                               scheme: "http", port: 3333,
                                               baseURL: FieroAPIEnum.BASE_URL.description,
                                               endPoint: QuickChallengeEndpointEnum.PATCH_CHALLENGES_FINISHED.description,
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
                        print("Failed to create request finish challenge endpoint: \(error)")
                    case .finished:
                        print("Successfully created request to finish challenge endpoint")
                }
            }, receiveValue: { [weak self] rawURLResponse in
                guard let response = rawURLResponse.item
                else {
                    print("Error while trying to finish challenge: \(rawURLResponse.statusCode)")
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
                print("Successfully finished challenge: \(rawURLResponse.statusCode)")

            })
            .store(in: &cancellables)
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error})
            .eraseToAnyPublisher()
    }
    
    //MARK: - Patch Score
    @discardableResult
    func patchScore(challengeId: String, teamId: String, memberId: String, score: Double) -> AnyPublisher<Member, HTTPResponseError> {
        
        let json = """
        {
            "score" : \(score)
        }
        """
        
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                let request = makePATCHRequestScore(json: json,
                                                    challengeId: challengeId,
                                                    teamId: teamId,
                                                    memberId: memberId,
                                                    variableToBePatched: VariablesToBePatchedQuickChallenge.score.description,
                                                    scheme: "http",
                                                    port: 3333,
                                                    baseURL: FieroAPIEnum.BASE_URL.description,
                                                    endPoint: QuickChallengeEndpointEnum.PATCH_CHALLENGES_SCORE.description,
                                                    authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: QuickChallengePATCHScoreResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .tryMap({ rawURLResponse -> Member in
                if let member = rawURLResponse.item?.member {
                    return member
                }
                else {
                    throw (HTTPResponseError(rawValue: rawURLResponse.statusCode) ?? .unknown)
                }
            })
            .mapError({ $0 as? HTTPResponseError ?? .unknown })
            .share()
        
        operation
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                    case .failure(let error):
                        switch error {
                            case .badRequest:
                                self?.editPlayerScoreAlertCases = .challengeError
                            case .notFound:
                                self?.editPlayerScoreAlertCases = .challengeNotFound
                            case .internalServerError:
                                self?.editPlayerScoreAlertCases = .internalServerError
                            case .unauthorized:
                                self?.editPlayerScoreAlertCases = .playerNotInChallenge
                            default:
                                self?.editPlayerScoreAlertCases = .unknown
                        }
                        print("Failed to create request to patch score endpoint: \(error)")
                    case .finished:
                        print("Successfully created request to patch score endpoint")
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)
        
        return operation
            .eraseToAnyPublisher()
    }
    
    //MARK: - Exit Challenge
    @discardableResult
    func exitChallenge(by id: String) -> AnyPublisher<Void, Error> {
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                let request = makeDELETERequest(param: id, scheme: "http", port: 3333, baseURL: FieroAPIEnum.BASE_URL.description, endPoint: QuickChallengeEndpointEnum.EXIT_CHALLENGE.description, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: QuickChallengeDELETEResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .share()
        
        operation.sink(receiveCompletion: { [weak self] completion in
            switch completion {
                case .failure(let error):
                    print("Failed to create request to exit challenge endpoint: \(error)")
                    self?.exitChallengeAlertCases = .internalServerError
                case .finished:
                    print("Successfully created request to exit challenge endpoint")
            }
        }, receiveValue: { [weak self] rawURLResponse in
            guard let _ = rawURLResponse.item else {
                
                if rawURLResponse.statusCode == 400 {
                    print("error while trying to exit challenge: \(rawURLResponse.statusCode)")
                    self?.exitChallengeAlertCases = .userNotInChallenge
                    return
                }
                
                if rawURLResponse.statusCode == 404 {
                    print("error while trying to exit challenge: \(rawURLResponse.statusCode)")
                    self?.exitChallengeAlertCases = .userOrChallengeNotFound
                    return
                }
                
                if rawURLResponse.statusCode == 500 {
                    print("error while trying to exit challenge: \(rawURLResponse.statusCode)")
                    self?.exitChallengeAlertCases = .internalServerError
                    return
                }
                print("error while trying to exit challenge: \(rawURLResponse.statusCode)")
                return
            }
            
            print("Successfully exited from challenge: \(rawURLResponse.statusCode)")
            self?.challengesList.removeAll(where: { $0.id == id })

            self?.exitChallengeAlertCases = .none
        })
        .store(in: &cancellables)
        
        return operation
            .map({ _ in () })
            .mapError({ $0 as Error })
            .eraseToAnyPublisher()
    }
    
    //MARK: - Remove Participant
    @discardableResult
    func remove(participant userID: String, from challengeID: String) -> AnyPublisher<QuickChallenge, HTTPResponseError> {
        let json = """
        {
            "userToDeleteId" : "\(userID)"
        }
        """
        
        let operation = self.authTokenService.getAuthToken()
            .flatMap({ authToken in
                let request = makeDELETERequest(param: challengeID, body: json, scheme: "http", port: 3333, baseURL: FieroAPIEnum.BASE_URL.description, endPoint: QuickChallengeEndpointEnum.REMOVE_PARTICIPANT.description, authToken: authToken)
                
                return self.client.perform(for: request)
            })
            .decodeHTTPResponse(type: QuickChallengePATCHResponse.self, decoder: JSONDecoder())
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .tryMap({ rawURLResponse -> QuickChallenge in
                if let quickChallenge = rawURLResponse.item?.quickChallenge {
                    return quickChallenge
                }
                else {
                    throw (HTTPResponseError(rawValue: rawURLResponse.statusCode) ?? .unknown)
                }
            })
            .mapError({ $0 as? HTTPResponseError ?? .unknown })
            .share()
        
        operation
            .sink(receiveCompletion: { [weak self] completion in
            switch completion {
                case .failure(let error):
                    switch error {
                        case .badRequest:
                            self?.removePlayerAlertCases = .userNotInThisChallenge
                        case .notFound:
                            self?.removePlayerAlertCases = .userOrChallengeNotFound
                        case .internalServerError:
                            self?.removePlayerAlertCases = .internalServerError
                        case .unauthorized:
                            self?.removePlayerAlertCases = .unauthorizedToRemove
                        case .success:
                            self?.removePlayerAlertCases = .userRemoved
                        default:
                            self?.removePlayerAlertCases = .internalServerError
                    }
                    print("Failed to create request to remove participant from challenge endpoint: \(error)")
                case .finished:
                    print("Successfully created request to remove participant from challenge endpoint")
            }
        }, receiveValue: { _ in })
        .store(in: &cancellables)
        
        return operation
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
