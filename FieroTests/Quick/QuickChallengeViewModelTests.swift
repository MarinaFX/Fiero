//
//  QuickChallengeViewModelTests.swift
//  FieroTests
//
//  Created by Marina De Pazzi on 07/08/22.
//

import XCTest
import Combine
@testable import Fiero

//MARK: QuickChallengeViewModelTests
class QuickChallengeViewModelTests: XCTestCase {
    //MARK: - Variables Setup
    var sut: QuickChallengeViewModel!
    var mockClient: MockHTTPClient!
    var mockKeyValueStorage: MockKeyValueStorage!
    
    var cancellables: Set<AnyCancellable> = []
    
    //MARK: - Test Environment Setup
    override func setUpWithError() throws {
        self.mockClient = MockHTTPClient(url: "", statusCode: 0, json: "")
        self.mockKeyValueStorage = MockKeyValueStorage(dictionary: ["AuthToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImQxNWNkYTdmLWU2MTktNDI4MS1hMDdjLWE4NDhlZGMwMjEzYiIsImlhdCI6MTY1OTk4ODE3MywiZXhwIjoxNjU5OTg5OTczfQ.DfcbguU-ncL0Xe7MzaMlS5cGCC7ilxFkqudMzOcA67I"])
        self.sut = .init(client: self.mockClient, keyValueStorage: self.mockKeyValueStorage)
    }
    
    override func tearDownWithError() throws {
        self.sut = nil
        self.cancellables.removeAll()
    }
    
    private func getJSON() -> String {
        return """
        {
            "quickChallenge": [
                {
                    "id": "2642554d-eec5-4a84-90b5-d8c7385460b0",
                    "name": "TRUCO 2",
                    "invitationCode": "22758ac7-ad20-4cec-9a2b-e00b8c9efd33",
                    "type": "amount",
                    "goal": 115,
                    "goalMeasure": "unity",
                    "finished": false,
                    "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
                    "online": false,
                    "alreadyBegin": false,
                    "maxTeams": 2,
                    "createdAt": "2022-08-08T05:27:01.856Z",
                    "updatedAt": "2022-08-08T05:27:01.856Z",
                    "owner": {
                        "id": "d15cda7f-e619-4281-a07c-a848edc0213b",
                        "email": "qw@qw.com",
                        "name": "qw",
                        "createdAt": "2022-08-05T23:18:19.441Z",
                        "updatedAt": "2022-08-05T23:18:19.441Z"
                    },
                    "teams": [
                        {
                            "id": "e01d89ab-495b-4362-a246-b480c1d76ac7",
                            "name": "qw",
                            "quickChallengeId": "2642554d-eec5-4a84-90b5-d8c7385460b0",
                            "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
                            "createdAt": "2022-08-08T05:27:01.891Z",
                            "updatedAt": "2022-08-08T05:27:01.891Z",
                            "members": [
                                {
                                    "id": "2db8e04b-cf0a-4bb3-9dc5-0353add22eaf",
                                    "score": 0,
                                    "userId": "d15cda7f-e619-4281-a07c-a848edc0213b",
                                    "teamId": "e01d89ab-495b-4362-a246-b480c1d76ac7",
                                    "beginDate": null,
                                    "botPicture": null,
                                    "createdAt": "2022-08-08T05:27:01.914Z",
                                    "updatedAt": "2022-08-08T05:27:01.914Z"
                                }
                            ]
                        },
                        {
                            "id": "e8bfa066-4f92-495c-91e3-ea5f9abc1856",
                            "name": "picture2",
                            "quickChallengeId": "2642554d-eec5-4a84-90b5-d8c7385460b0",
                            "ownerId": null,
                            "createdAt": "2022-08-08T05:27:01.891Z",
                            "updatedAt": "2022-08-08T05:27:01.891Z",
                            "members": [
                                {
                                    "id": "e99c4b6f-f45e-4649-a1e4-c9e06f343c9e",
                                    "score": 0,
                                    "userId": null,
                                    "teamId": "e8bfa066-4f92-495c-91e3-ea5f9abc1856",
                                    "beginDate": null,
                                    "botPicture": "picture2",
                                    "createdAt": "2022-08-08T05:27:01.914Z",
                                    "updatedAt": "2022-08-08T05:27:01.914Z"
                                }
                            ]
                        }
                    ]
                }
            ]
        }
        """
    }
    
    //MARK: - Test Cases
    //MARK: Successful QC creation - Amount
    func testSuccessfulQuickChallengeAmountCreation() {
        //given
        let expectation = expectation(description: #function)
        
        let json = getJSON()
        
        self.mockClient.mock(url: "/quickChallenge/create", statusCode: 201, json: json)
        //when
        self.sut.$serverResponse
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        self.sut.createQuickChallenge(name: "TRUCO 2", challengeType: .amount, goal: 115, goalMeasure: "unity", numberOfTeams: 2, maxTeams: 2)
        wait(for: [expectation], timeout: 5)
        
        //then
        XCTAssertEqual(self.sut.serverResponse, .created)
    }
    
    //MARK: Wrong Goal Measure QC creation - Amount
    func testWrongGoalMeasureForQCByAmountCreation() {
        //given
        let expectation = expectation(description: #function)
        
        let json = """
        {
            "message": "invalid goalMeasure for Amount type",
            "validMeasures": [
                "unity"
            ]
        }
        """
        
        self.mockClient.mock(url: "/quickChallenge/create", statusCode: 400, json: json)
        
        //when
        self.sut.$serverResponse
            .dropFirst()
            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { _ in
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        self.sut.createQuickChallenge(name: "Shape dos fellas", challengeType: .amount, goal: 115, goalMeasure: "seconds", numberOfTeams: 3, maxTeams: 3)
        wait(for: [expectation], timeout: 5)
        
        //then
        XCTAssertEqual(self.sut.serverResponse, .badRequest)
    }
}
