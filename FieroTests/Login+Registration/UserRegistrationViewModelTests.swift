//
//  UserRegistrationViewModelTests.swift
//  FieroTests
//
//  Created by Marina De Pazzi on 14/07/22.
//

import Combine
import XCTest

@testable import Fiero

class UserRegistrationViewModelTests: XCTestCase {
    
    var sut: UserViewModel!
    var mockClient: MockHTTPClient!

    var disposables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        self.mockClient = MockHTTPClient(url: "", statusCode: 0, json: "")
        self.sut = .init(client: mockClient)
    }
    
    override func tearDownWithError() throws {
        self.mockClient = nil
        self.sut = nil
    }
    
    func testSuccessfulAccountCreation() {
        let expectation = expectation(description: #function)
        
        let json = """
        {
            "user": {
                "id": "64cb545e-6e40-4376-8805-fc7cc1b87cee",
                "name": "Minato",
                "email": "namikaze@kohona.com",
                "createdAt": "2022-07-15T21:11:30.675Z",
                "updatedAt": "2022-07-15T21:11:30.675Z"
            }
        }
        """
        
        self.mockClient.mock(url: "/register", statusCode: 200, json: json)
        
        self.sut.$serverResponse
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &disposables)
        
        self.sut.signup(for: User(email: "namikaze@kohona.com", name: "Minato", password: "Hiraishin"))
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(self.sut.serverResponse, .success)
    }
    
    func testAccountCreationWithInvalidEmail() {
        let expectation = expectation(description: #function)
        
        let json = """
        {
            "errors": [
                {
                    "value": "namikazekohona.com",
                    "msg": "Invalid value",
                    "param": "email",
                    "location": "body"
                }
            ]
        }
        """
        
        self.mockClient.mock(url: "/register", statusCode: 400, json: json)
        
        self.sut.$serverResponse
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &disposables)
        
        self.sut.signup(for: User(email: "namikaze@kohona", name: "Minato", password: "Hiraishin"))
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(self.sut.serverResponse, .badRequest)
    }
    
    func testCreateAccountWithAnEmailAlreadyRegistered() {
        let expectation = expectation(description: #function)
        
        let json = """
        {
            "duplicate key value violates unique constraint \"UQ_e12875dfb3b1d92d7d7c5377e22\""
        }
        """
        
        self.mockClient.mock(url: "/register", statusCode: 409, json: json)
        
        self.sut.$serverResponse
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &disposables)
        
        self.sut.signup(for: User(email: "someEmailThatIsAlreadyRegistered@flemis.com", name: "Minato", password: "Hiraishin"))
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(self.sut.serverResponse, .conflict)
    }
}
