//
//  ChallengeListViewModel.swift
//  Fiero
//
//  Created by Natália Brocca dos Santos on 21/07/22.
//

import Foundation
import Combine

class ChallengeListViewModel: ObservableObject {
    @Published private(set) var quickChallengesList: [QuickChallenge]
    @Published private(set) var serverResponse: ServerResponse
    
    private let BASE_URL: String = "localhost"
    private let ENDPOINT: String = "/quickChallenge/createdByMe"
    
    private(set) var client: HTTPClient
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(client: HTTPClient = URLSession.shared) {
        self.client = client
        self.serverResponse = .unknown
        self.quickChallengesList = []
    }
    
    func getAllQuickChallengesList() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.port = 3333
        urlComponents.host = BASE_URL
        urlComponents.path = ENDPOINT
        
        let url = urlComponents.url!
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "AuthToken")
        guard let token = token else {
            return
        }
        
        request.addValue(token, forHTTPHeaderField: "AuthToken")
        
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
            }, receiveValue: { [weak self] httpResponse in
                if let response = httpResponse.item {
                    self?.quickChallengesList = response.quickChallenge
                }
                self?.serverResponse.statusCode = httpResponse.statusCode
                print(self?.quickChallengesList as Any)
                print(self?.serverResponse.statusCode as Any)
            })
            .store(in: &cancellables)
    }
}
