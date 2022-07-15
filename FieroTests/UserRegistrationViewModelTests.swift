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
    
    var sut: UserRegistrationViewModel!
    var user: User = User(email: "", name: "")
    var response: HTTPURLResponse!
    var disposables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        //sut = .init(client: MockHTTPClient(url: "", statusCode: 0, json: ""))
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
}
