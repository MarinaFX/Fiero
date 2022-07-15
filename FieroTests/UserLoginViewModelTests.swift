//
//  UserLoginViewModelTests.swift
//  FieroTests
//
//  Created by Marina De Pazzi on 13/07/22.
//

import XCTest
import Combine
@testable import Fiero

class UserLoginViewModelTests: XCTestCase {
    
    var sut: UserLoginViewModel!
    var mockClient: MockHTTPClient!

    var disposables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        self.mockClient = MockHTTPClient(url: "", statusCode: 0, json: "")
        self.sut = .init(client: self.mockClient)
    }
    
    override func tearDownWithError() throws {
        self.sut = nil
    }
    
    func testSuccessfulLoginRequest() {
        let expectation = expectation(description: #function)
        expectation.expectedFulfillmentCount = 2
        
        let json = """
        {
            "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjhkZDlhODc2LThjZTUtNGEzMy1hY2IwLWJjYzg5YzlmOTczNCIsImlhdCI6MTY1NzkwNjQ2MiwiZXhwIjoxNjU3OTA4MjYyfQ.XH3YLs4iIVcvnV3g0lnFBl5yd7AcWBBsYmK-BHqr8NY",
            "user": {
                "id": "8dd9a876-8ce5-4a33-acb0-bcc89c9f9734",
                "name": "Marina De Pazzi",
                "email": "pazzi.dev@gmail.com",
                "createdAt": "2022-07-10T23:00:58.539Z",
                "updatedAt": "2022-07-10T23:00:58.539Z"
            }
        }
        """
        
        self.mockClient.mock(url: "/login", statusCode: 200, json: json)
        
        self.sut.$user
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &disposables)
        
        self.sut.authenticateUser(email: "pazzi.dev@gmail.com", password: "Marina115")
        
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(self.sut.serverResponse, .success)
        XCTAssertEqual(self.sut.user.email, "pazzi.dev@gmail.com")
        XCTAssertEqual(self.sut.user.name, "Marina De Pazzi")
        XCTAssertEqual(self.sut.user.id, "8dd9a876-8ce5-4a33-acb0-bcc89c9f9734")
    }
    
    func testLoginWithWrongEmailRequest() {
        let expectation = expectation(description: #function)

        let json = """
        {
            "user not found"
        }
        """
        
        self.mockClient.mock(url: "/login", statusCode: 404, json: json)

        self.sut.$serverResponse
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &disposables)

        self.sut.authenticateUser(email: "someemail@someprovider.com", password: "flemis")
        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(self.sut.serverResponse, .notFound)
        XCTAssertEqual(self.sut.user.email, "")
        XCTAssertEqual(self.sut.user.name, "")
        XCTAssertEqual(self.sut.user.id, nil)
    }
    
    func testLoginWithWrongPasswordRequest() {
        let expectation = expectation(description: #function)

        let json = """
        {
            "wrong email + password combination"
        }
        """
        
        self.mockClient.mock(url: "/login", statusCode: 403, json: json)

        self.sut.$serverResponse
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &disposables)
        
        self.sut.authenticateUser(email: "pazzi.dev@gmail.com", password: "someWrongPassword")
        wait(for: [expectation], timeout: 5)

        XCTAssertEqual(self.sut.serverResponse, .forbidden)
    }
    
    func testLoginWithInvalidEmail() {
        let expectation = expectation(description: #function)
                
        let json = """
        {
            "errors": [
                {
                    "value": "someWrongEmailgmail",
                    "msg": "Invalid value",
                    "param": "email",
                    "location": "body"
                }
            ]
        }
        """
        
        self.mockClient.mock(url: "/login", statusCode: 400, json: json)
        
        self.sut.$serverResponse
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &disposables)
        
        self.sut.authenticateUser(email: "someWrongEmailgmail.com", password: "somePassword")
        wait(for: [expectation], timeout: 5)
        
        XCTAssertEqual(self.sut.serverResponse, .badRequest)
    }
}
