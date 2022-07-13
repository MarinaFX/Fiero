//
//  UserLoginViewModelTests.swift
//  FieroTests
//
//  Created by Marina De Pazzi on 13/07/22.
//

import XCTest
import Combine
@testable import Fiero

struct MockHTTPClient: HTTPClient {
    func perform(for request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        if request.url!.absoluteString.contains("/login") {
            let json = "{ \"token\" : \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjhkZDlhODc2LThjZTUtNGEzMy1hY2IwLWJjYzg5YzlmOTczNCIsImlhdCI6MTY1NzczMjA3OSwiZXhwIjoxNjU3NzMzODc5fQ.qtaj83WttXWBdtc4Bm-ByzKSSIvB9WKbh6DGC6l5S50\", \"user\" : { \"id\" : \"8dd9a876-8ce5-4a33-acb0-bcc89c9f9734\", \"name\": \"Marina De Pazzi\", \"email\": \"pazzi.dev@gmail.com\", \"createdAt\": \"2022-07-10T23:00:58.539Z\", \"updatedAt\": \"2022-07-10T23:00:58.539Z\"} }"
            
            let jsonData = json.data(using: .utf8)!
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "1.1", headerFields: nil)!
            
            return Just((data: jsonData, response: response))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Empty()
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

class UserLoginViewModelTests: XCTestCase {
    
    var sut: UserLoginViewModel!
    var user: User = User(email: "", name: "")
    var response: HTTPURLResponse!
    var disposables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        sut = .init(client: MockHTTPClient())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func testSuccessfulUserLoginRequest() {
        let userExpectation = expectation(description: "async user auth")
        
        sut.client
            .perform(for: URLRequest(url: URL(string: "http://localhost:3333/user/login")!))
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            //.dropFirst()
            .sink(receiveCompletion: { result in
                switch result {
                    case .failure (let error):
                        print("completion failed with: \(error.localizedDescription)")
                    case .finished:
                        print("completion executed successfully")
                }
            }, receiveValue: { [weak self] data, response in
                guard let response = response as? HTTPURLResponse else { return }
                
                switch response.statusCode {
                    case 200:
                        let userResponse = try! JSONDecoder().decode(UserResponse.self, from: data)
                        self?.response = response
                        self?.user = userResponse.user
                        self?.user.token = userResponse.token
                        userExpectation.fulfill()

                    default:
                        print(response.statusCode)
                }
            })
            .store(in: &disposables)
        
        //sut.authenticateUser(email: "pazzi.dev@gmail.com", password: "Marina115")
        
        wait(for: [userExpectation], timeout: 5)
        
        XCTAssertEqual(self.response.statusCode, 200)
        XCTAssertEqual(self.user.email, "pazzi.dev@gmail.com")
        XCTAssertEqual(self.user.name, "Marina De Pazzi")
        XCTAssertEqual(self.user.id, "8dd9a876-8ce5-4a33-acb0-bcc89c9f9734")
    }
}
