////
////  QuickChallengeViewModelTests.swift
////  FieroTests
////
////  Created by Marina De Pazzi on 07/08/22.
////
//
//import XCTest
//import Combine
//@testable import Fiero
//
////MARK: QuickChallengeViewModelTests
//class QuickChallengeViewModelTests: XCTestCase {
//    //MARK: - Variables Setup
//    var sut: QuickChallengeViewModel!
//    var mockClient: MockHTTPClient!
//    var mockKeyValueStorage: MockKeyValueStorage!
//    var expTimeout: Double = 2
//    
//    var cancellables: Set<AnyCancellable> = []
//    
//    //MARK: - Test Environment Setup
//    override func setUpWithError() throws {
//        self.mockClient = MockHTTPClient(url: "", statusCode: 0, json: "")
//        self.mockKeyValueStorage = MockKeyValueStorage(dictionary: ["AuthToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImQxNWNkYTdmLWU2MTktNDI4MS1hMDdjLWE4NDhlZGMwMjEzYiIsImlhdCI6MTY1OTk4ODE3MywiZXhwIjoxNjU5OTg5OTczfQ.DfcbguU-ncL0Xe7MzaMlS5cGCC7ilxFkqudMzOcA67I"])
//        self.sut = .init(client: self.mockClient, keyValueStorage: self.mockKeyValueStorage)
//    }
//    
//    override func tearDownWithError() throws {
//        self.sut = nil
//        self.cancellables.removeAll()
//    }
//    
//    private func getJSONResponseForPOSTRequest() -> String {
//        return """
//        {
//            "quickChallenge": [
//                {
//                    "id": "2642554d-eec5-4a84-90b5-d8c7385460b0",
//                    "name": "TRUCO 2",
//                    "invitationCode": "22758ac7-ad20-4cec-9a2b-e00b8c9efd33",
//                    "type": "amount",
//                    "goal": 115,
//                    "goalMeasure": "unity",
//                    "finished": false,
//                    "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                    "online": false,
//                    "alreadyBegin": false,
//                    "maxTeams": 2,
//                    "createdAt": "2022-08-08T05:27:01.856Z",
//                    "updatedAt": "2022-08-08T05:27:01.856Z",
//                    "owner": {
//                        "id": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                        "email": "qw@qw.com",
//                        "name": "qw",
//                        "createdAt": "2022-08-05T23:18:19.441Z",
//                        "updatedAt": "2022-08-05T23:18:19.441Z"
//                    },
//                    "teams": [
//                        {
//                            "id": "e01d89ab-495b-4362-a246-b480c1d76ac7",
//                            "name": "qw",
//                            "quickChallengeId": "2642554d-eec5-4a84-90b5-d8c7385460b0",
//                            "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                            "createdAt": "2022-08-08T05:27:01.891Z",
//                            "updatedAt": "2022-08-08T05:27:01.891Z",
//                            "members": [
//                                {
//                                    "id": "2db8e04b-cf0a-4bb3-9dc5-0353add22eaf",
//                                    "score": 0,
//                                    "userId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                                    "teamId": "e01d89ab-495b-4362-a246-b480c1d76ac7",
//                                    "beginDate": null,
//                                    "botPicture": null,
//                                    "createdAt": "2022-08-08T05:27:01.914Z",
//                                    "updatedAt": "2022-08-08T05:27:01.914Z"
//                                }
//                            ]
//                        },
//                        {
//                            "id": "e8bfa066-4f92-495c-91e3-ea5f9abc1856",
//                            "name": "picture2",
//                            "quickChallengeId": "2642554d-eec5-4a84-90b5-d8c7385460b0",
//                            "ownerId": null,
//                            "createdAt": "2022-08-08T05:27:01.891Z",
//                            "updatedAt": "2022-08-08T05:27:01.891Z",
//                            "members": [
//                                {
//                                    "id": "e99c4b6f-f45e-4649-a1e4-c9e06f343c9e",
//                                    "score": 0,
//                                    "userId": null,
//                                    "teamId": "e8bfa066-4f92-495c-91e3-ea5f9abc1856",
//                                    "beginDate": null,
//                                    "botPicture": "picture2",
//                                    "createdAt": "2022-08-08T05:27:01.914Z",
//                                    "updatedAt": "2022-08-08T05:27:01.914Z"
//                                }
//                            ]
//                        }
//                    ]
//                }
//            ]
//        }
//        """
//    }
//    
//    private func getJSONResponseForGETRequest() -> String {
//        return """
//        {
//            "quickChallenges": [
//                {
//                    "id": "7511c0ca-7330-4b8f-b0e9-9927ad897daf",
//                    "name": "Primeira",
//                    "invitationCode": "901e8892-5ec8-4d24-b16d-5285974470c3",
//                    "type": "amount",
//                    "goal": 1111,
//                    "goalMeasure": "unity",
//                    "finished": false,
//                    "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                    "online": false,
//                    "alreadyBegin": false,
//                    "maxTeams": 2,
//                    "createdAt": "2022-08-17T22:35:08.761Z",
//                    "updatedAt": "2022-08-17T22:35:08.761Z",
//                    "teams": [
//                        {
//                            "id": "119ba5ff-a7e4-4dae-91d2-af26b7fd9943",
//                            "name": "qw",
//                            "quickChallengeId": "7511c0ca-7330-4b8f-b0e9-9927ad897daf",
//                            "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                            "createdAt": "2022-08-17T22:35:08.769Z",
//                            "updatedAt": "2022-08-17T22:35:08.769Z",
//                            "members": [
//                                {
//                                    "id": "c46bdc81-8965-477d-bb95-d7fb08c5473c",
//                                    "score": 0,
//                                    "userId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                                    "teamId": "119ba5ff-a7e4-4dae-91d2-af26b7fd9943",
//                                    "beginDate": null,
//                                    "botPicture": null,
//                                    "createdAt": "2022-08-17T22:35:08.775Z",
//                                    "updatedAt": "2022-08-17T22:35:08.775Z"
//                                }
//                            ]
//                        },
//                        {
//                            "id": "f84d6990-a835-4588-9c48-2926fa97922e",
//                            "name": "player2",
//                            "quickChallengeId": "7511c0ca-7330-4b8f-b0e9-9927ad897daf",
//                            "ownerId": null,
//                            "createdAt": "2022-08-17T22:35:08.769Z",
//                            "updatedAt": "2022-08-17T22:35:08.769Z",
//                            "members": [
//                                {
//                                    "id": "bb0cc161-1aa6-475f-9ee0-173bd89f84e6",
//                                    "score": 0,
//                                    "userId": null,
//                                    "teamId": "f84d6990-a835-4588-9c48-2926fa97922e",
//                                    "beginDate": null,
//                                    "botPicture": "player2",
//                                    "createdAt": "2022-08-17T22:35:08.775Z",
//                                    "updatedAt": "2022-08-17T22:35:08.775Z"
//                                }
//                            ]
//                        }
//                    ],
//                    "owner": {
//                        "id": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                        "email": "qw@qw.com",
//                        "name": "qw",
//                        "createdAt": "2022-08-05T23:18:19.441Z",
//                        "updatedAt": "2022-08-05T23:18:19.441Z"
//                    }
//                },
//                {
//                    "id": "842d8deb-9d9f-4b60-b43e-7efdb70ac175",
//                    "name": "BRENDA RAINHA",
//                    "invitationCode": "ff5a710d-1b85-47e4-8b3c-44e9e52fabd4",
//                    "type": "amount",
//                    "goal": 11111,
//                    "goalMeasure": "unity",
//                    "finished": false,
//                    "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                    "online": false,
//                    "alreadyBegin": false,
//                    "maxTeams": 3,
//                    "createdAt": "2022-08-18T20:57:00.313Z",
//                    "updatedAt": "2022-08-18T20:57:00.313Z",
//                    "teams": [
//                        {
//                            "id": "a69c0471-5c14-4280-80c5-305ee4de2815",
//                            "name": "qw",
//                            "quickChallengeId": "842d8deb-9d9f-4b60-b43e-7efdb70ac175",
//                            "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                            "createdAt": "2022-08-18T20:57:00.322Z",
//                            "updatedAt": "2022-08-18T20:57:00.322Z",
//                            "members": [
//                                {
//                                    "id": "defb5e16-288f-45e1-b682-c8193d705a11",
//                                    "score": 0,
//                                    "userId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                                    "teamId": "a69c0471-5c14-4280-80c5-305ee4de2815",
//                                    "beginDate": null,
//                                    "botPicture": null,
//                                    "createdAt": "2022-08-18T20:57:00.331Z",
//                                    "updatedAt": "2022-08-18T20:57:00.331Z"
//                                }
//                            ]
//                        },
//                        {
//                            "id": "b752877e-d36f-4ae7-be67-65ecfb8a31bb",
//                            "name": "player2",
//                            "quickChallengeId": "842d8deb-9d9f-4b60-b43e-7efdb70ac175",
//                            "ownerId": null,
//                            "createdAt": "2022-08-18T20:57:00.322Z",
//                            "updatedAt": "2022-08-18T20:57:00.322Z",
//                            "members": [
//                                {
//                                    "id": "56a1efe0-4edd-41d5-94e5-3750d4bee1b5",
//                                    "score": 0,
//                                    "userId": null,
//                                    "teamId": "b752877e-d36f-4ae7-be67-65ecfb8a31bb",
//                                    "beginDate": null,
//                                    "botPicture": "player2",
//                                    "createdAt": "2022-08-18T20:57:00.331Z",
//                                    "updatedAt": "2022-08-18T20:57:00.331Z"
//                                }
//                            ]
//                        },
//                        {
//                            "id": "879453f3-9d05-4c0a-a550-c546f5b3c180",
//                            "name": "player3",
//                            "quickChallengeId": "842d8deb-9d9f-4b60-b43e-7efdb70ac175",
//                            "ownerId": null,
//                            "createdAt": "2022-08-18T20:57:00.322Z",
//                            "updatedAt": "2022-08-18T20:57:00.322Z",
//                            "members": [
//                                {
//                                    "id": "7f1fc6c6-8d82-4981-b7ca-e89e42e83ae5",
//                                    "score": 0,
//                                    "userId": null,
//                                    "teamId": "879453f3-9d05-4c0a-a550-c546f5b3c180",
//                                    "beginDate": null,
//                                    "botPicture": "player3",
//                                    "createdAt": "2022-08-18T20:57:00.331Z",
//                                    "updatedAt": "2022-08-18T20:57:00.331Z"
//                                }
//                            ]
//                        }
//                    ],
//                    "owner": {
//                        "id": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                        "email": "qw@qw.com",
//                        "name": "qw",
//                        "createdAt": "2022-08-05T23:18:19.441Z",
//                        "updatedAt": "2022-08-05T23:18:19.441Z"
//                    }
//                },
//                {
//                    "id": "a36e24a7-bcd1-483c-8444-39668c816c79",
//                    "name": "CASA CMG ",
//                    "invitationCode": "ba4b6ae9-3e98-4366-b22e-17f01f8b9dd4",
//                    "type": "amount",
//                    "goal": 11111,
//                    "goalMeasure": "unity",
//                    "finished": false,
//                    "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                    "online": false,
//                    "alreadyBegin": false,
//                    "maxTeams": 2,
//                    "createdAt": "2022-08-18T20:57:20.303Z",
//                    "updatedAt": "2022-08-18T20:57:20.303Z",
//                    "teams": [
//                        {
//                            "id": "26a0d8e9-d887-4ea7-bd1d-242b91e2fdf2",
//                            "name": "qw",
//                            "quickChallengeId": "a36e24a7-bcd1-483c-8444-39668c816c79",
//                            "ownerId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                            "createdAt": "2022-08-18T20:57:20.311Z",
//                            "updatedAt": "2022-08-18T20:57:20.311Z",
//                            "members": [
//                                {
//                                    "id": "5a7db1a7-ae20-488d-86af-d163a1169229",
//                                    "score": 0,
//                                    "userId": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                                    "teamId": "26a0d8e9-d887-4ea7-bd1d-242b91e2fdf2",
//                                    "beginDate": null,
//                                    "botPicture": null,
//                                    "createdAt": "2022-08-18T20:57:20.318Z",
//                                    "updatedAt": "2022-08-18T20:57:20.318Z"
//                                }
//                            ]
//                        },
//                        {
//                            "id": "66527ece-8a90-41cf-acc5-ff9896acabf5",
//                            "name": "player2",
//                            "quickChallengeId": "a36e24a7-bcd1-483c-8444-39668c816c79",
//                            "ownerId": null,
//                            "createdAt": "2022-08-18T20:57:20.311Z",
//                            "updatedAt": "2022-08-18T20:57:20.311Z",
//                            "members": [
//                                {
//                                    "id": "7436e8cf-b898-4b6a-8473-1c36c7bc4d2d",
//                                    "score": 0,
//                                    "userId": null,
//                                    "teamId": "66527ece-8a90-41cf-acc5-ff9896acabf5",
//                                    "beginDate": null,
//                                    "botPicture": "player2",
//                                    "createdAt": "2022-08-18T20:57:20.318Z",
//                                    "updatedAt": "2022-08-18T20:57:20.318Z"
//                                }
//                            ]
//                        }
//                    ],
//                    "owner": {
//                        "id": "d15cda7f-e619-4281-a07c-a848edc0213b",
//                        "email": "qw@qw.com",
//                        "name": "qw",
//                        "createdAt": "2022-08-05T23:18:19.441Z",
//                        "updatedAt": "2022-08-05T23:18:19.441Z"
//                    }
//                }
//            ]
//        }
//        """
//    }
//    
//    private func getJSONResponseForFailDELETERequest() -> String {
//        return """
//        {
//            "error": {
//                "query": "SELECT DISTINCT \\"distinctAlias\\".\\"QuickChallenge_id\\" as \\"ids_QuickChallenge_id\\" FROM (SELECT \\"QuickChallenge\\".\\"id\\" AS \\"QuickChallenge_id\\", \\"QuickChallenge\\".\\"name\\" AS \\"QuickChallenge_name\\", \\"QuickChallenge\\".\\"invitationCode\\" AS \\"QuickChallenge_invitationCode\\", \\"QuickChallenge\\".\\"owner_id\\" AS \\"QuickChallenge_owner_id\\", \\"QuickChallenge\\".\\"type\\" AS \\"QuickChallenge_type\\", \\"QuickChallenge\\".\\"goal\\" AS \\"QuickChallenge_goal\\", \\"QuickChallenge\\".\\"goalMeasure\\" AS \\"QuickChallenge_goalMeasure\\", \\"QuickChallenge\\".\\"finished\\" AS \\"QuickChallenge_finished\\", \\"QuickChallenge\\".\\"online\\" AS \\"QuickChallenge_online\\", \\"QuickChallenge\\".\\"alreadyBegin\\" AS \\"QuickChallenge_alreadyBegin\\", \\"QuickChallenge\\".\\"maxTeams\\" AS \\"QuickChallenge_maxTeams\\", \\"QuickChallenge\\".\\"created_At\\" AS \\"QuickChallenge_created_At\\", \\"QuickChallenge\\".\\"updated_At\\" AS \\"QuickChallenge_updated_At\\", \\"QuickChallenge_owner\\".\\"id\\" AS \\"QuickChallenge_owner_id\\", \\"QuickChallenge_owner\\".\\"name\\" AS \\"QuickChallenge_owner_name\\", \\"QuickChallenge_owner\\".\\"email\\" AS \\"QuickChallenge_owner_email\\", \\"QuickChallenge_owner\\".\\"created_At\\" AS \\"QuickChallenge_owner_created_At\\", \\"QuickChallenge_owner\\".\\"updated_At\\" AS \\"QuickChallenge_owner_updated_At\\", \\"QuickChallenge_teams\\".\\"id\\" AS \\"QuickChallenge_teams_id\\", \\"QuickChallenge_teams\\".\\"name\\" AS \\"QuickChallenge_teams_name\\", \\"QuickChallenge_teams\\".\\"quickChallenge_id\\" AS \\"QuickChallenge_teams_quickChallenge_id\\", \\"QuickChallenge_teams\\".\\"owner_id\\" AS \\"QuickChallenge_teams_owner_id\\", \\"QuickChallenge_teams\\".\\"created_At\\" AS \\"QuickChallenge_teams_created_At\\", \\"QuickChallenge_teams\\".\\"updated_At\\" AS \\"QuickChallenge_teams_updated_At\\", \\"QuickChallenge_teams_members\\".\\"id\\" AS \\"QuickChallenge_teams_members_id\\", \\"QuickChallenge_teams_members\\".\\"user_id\\" AS \\"QuickChallenge_teams_members_user_id\\", \\"QuickChallenge_teams_members\\".\\"team_id\\" AS \\"QuickChallenge_teams_members_team_id\\", \\"QuickChallenge_teams_members\\".\\"score\\" AS \\"QuickChallenge_teams_members_score\\", \\"QuickChallenge_teams_members\\".\\"beginDate\\" AS \\"QuickChallenge_teams_members_beginDate\\", \\"QuickChallenge_teams_members\\".\\"botPicture\\" AS \\"QuickChallenge_teams_members_botPicture\\", \\"QuickChallenge_teams_members\\".\\"created_At\\" AS \\"QuickChallenge_teams_members_created_At\\", \\"QuickChallenge_teams_members\\".\\"updated_At\\" AS \\"QuickChallenge_teams_members_updated_At\\" FROM \\"quick_challenge\\" \\"QuickChallenge\\" LEFT JOIN \\"user\\" \\"QuickChallenge_owner\\" ON \\"QuickChallenge_owner\\".\\"id\\"=\\"QuickChallenge\\".\\"owner_id\\"  LEFT JOIN \\"team\\" \\"QuickChallenge_teams\\" ON \\"QuickChallenge_teams\\".\\"quickChallenge_id\\"=\\"QuickChallenge\\".\\"id\\"  LEFT JOIN \\"team_user\\" \\"QuickChallenge_teams_members\\" ON \\"QuickChallenge_teams_members\\".\\"team_id\\"=\\"QuickChallenge_teams\\".\\"id\\" WHERE \\"QuickChallenge\\".\\"id\\" = $1) \\"distinctAlias\\" ORDER BY \\"QuickChallenge_id\\" ASC LIMIT 1",
//                "parameters": [
//                    "ad036213-c5d0-40b6-a304-6ad0dcbcd1372"
//                ],
//                "driverError": {
//                    "length": 169,
//                    "name": "error",
//                    "severity": "ERROR",
//                    "code": "22P02",
//                    "where": "unnamed portal parameter $1 = '...'",
//                    "file": "uuid.c",
//                    "line": "134",
//                    "routine": "string_to_uuid"
//                },
//                "length": 169,
//                "severity": "ERROR",
//                "code": "22P02",
//                "where": "unnamed portal parameter $1 = '...'",
//                "file": "uuid.c",
//                "line": "134",
//                "routine": "string_to_uuid"
//            }
//        }
//        """
//    }
//    
//    private func getJSONResponseForSuccessfulDELETERequest() -> String {
//        return """
//        {
//            "message": "successfully deleted."
//        }
//        """
//    }
//    
//    //MARK: - Test Cases
//    //MARK: Successful QC creation - Amount
//    func testSuccessfulQuickChallengeAmountCreation() {
//        //given
//        let serverResponseExpectation = expectation(description: #function + " serverResponseExpectation")
//        let challengesListExpectation = expectation(description: #function + " challengesListExpectation")
//        
//        let json = getJSONResponseForPOSTRequest()
//        
//        self.mockClient.mock(url: "/quickChallenge/create", statusCode: 201, json: json)
//        //when
//        self.sut.$serverResponse
//            .dropFirst(2)
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                serverResponseExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        //when
//        self.sut.$challengesList
//            .dropFirst()
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                challengesListExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//
//        self.sut.createQuickChallenge(name: "TRUCO 2", challengeType: .amount, goal: 115, goalMeasure: "unity", numberOfTeams: 2, maxTeams: 2)
//        wait(for: [serverResponseExpectation, challengesListExpectation], timeout: self.expTimeout)
//        
//        //then
//        XCTAssertEqual(self.sut.serverResponse, .created)
//        XCTAssertEqual(self.sut.challengesList.isEmpty, false)
//    }
//    
//    //MARK: Wrong Goal Measure QC creation - Amount
//    func testWrongGoalMeasureForQCByAmountCreation() {
//        //given
//        let serverResponseExpectation = expectation(description: #function + " serverResponseExpectation")
//        let challengesListExpectation = expectation(description: #function + " challengesListExpectation")
//        challengesListExpectation.isInverted = true
//
//        let json = """
//        {
//            "message": "invalid goalMeasure for Amount type",
//            "validMeasures": [
//                "unity"
//            ]
//        }
//        """
//        
//        self.mockClient.mock(url: "/quickChallenge/create", statusCode: 400, json: json)
//        
//        //when
//        self.sut.$serverResponse
//            .dropFirst(2)
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                serverResponseExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        //when
//        self.sut.$challengesList
//            .dropFirst()
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                challengesListExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        self.sut.createQuickChallenge(name: "Shape dos fellas", challengeType: .amount, goal: 115, goalMeasure: "seconds", numberOfTeams: 3, maxTeams: 3)
//        wait(for: [serverResponseExpectation, challengesListExpectation], timeout: self.expTimeout)
//        
//        //then
//        XCTAssertEqual(self.sut.serverResponse, .badRequest)
//        XCTAssertEqual(self.sut.challengesList.isEmpty, true)
//    }
//    
//    //MARK: GET challenges
//    func testSuccessfulGetChallenges() {
//        //given
//        let serverResponseExpectation = expectation(description: #function + " serverResponseExpectation")
//        let challengesListExpectation = expectation(description: #function + " challengesListExpectation")
//        
//        let json = getJSONResponseForGETRequest()
//        
//        self.mockClient.mock(url: "/quickChallenge/createdByMe", statusCode: 201, json: json)
//        
//        //when
//        self.sut.$serverResponse
//            .print("server response")
//            .dropFirst(2)
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                serverResponseExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        self.sut.$challengesList
//            .print("challenge List")
//            .dropFirst()
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                challengesListExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        self.sut.getUserChallenges()
//        wait(for: [serverResponseExpectation, challengesListExpectation], timeout: self.expTimeout)
//        
//        //then
//        XCTAssertEqual(self.sut.serverResponse, .created)
//        XCTAssertEqual(self.sut.challengesList.isEmpty, false)
//    }
//    
//    //MARK: Successful Delete a challenge by ID
//    func testSuccessfulDeleteChallengeByID() {
//        //given
//        let serverResponseExpectation = expectation(description: #function + " serverResponseExpectation")
//        let challengesListExpectation = expectation(description: #function + " challengesListExpectation")
//        
//        let json = getJSONResponseForSuccessfulDELETERequest()
//        
//        self.mockClient.mock(url: "/quickChallenge", statusCode: 201, json: json)
//        
//        self.sut.challengesList.append(QuickChallenge(id: "842d8deb-9d9f-4b60-b43e-7efdb70ac175", name: "flemis", invitationCode: "", type: "", goal: 115, goalMeasure: "unity", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 2, createdAt: "", updatedAt: "", teams: [], owner: User(email: "tester@tester.com", name: "tester")))
//        
//        //when
//        self.sut.$serverResponse
//            .dropFirst(2)
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                serverResponseExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        //when
//        self.sut.$challengesList
//            .dropFirst()
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                challengesListExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        self.sut.deleteChallenge(by: "842d8deb-9d9f-4b60-b43e-7efdb70ac175")
//        wait(for: [challengesListExpectation, serverResponseExpectation], timeout: self.expTimeout)
//        
//        //then
//        XCTAssertEqual(self.sut.serverResponse, .created)
//        XCTAssertEqual(self.sut.challengesList.isEmpty, true)
//    }
//    
//    //MARK: Unsuccessful Delete a challenge by ID
//    func testDeleteChallengeByNonExistantID() {
//        //given
//        let serverResponseExpectation = expectation(description: #function + " serverResponseExpectation")
//        let challengesListExpectation = expectation(description: #function + " challengesListExpectation")
//        challengesListExpectation.isInverted = true
//        
//        let json = getJSONResponseForFailDELETERequest()
//        
//        self.mockClient.mock(url: "/quickChallenge", statusCode: 500, json: json)
//        
//        self.sut.challengesList.append(QuickChallenge(id: "842d8deb-9d9f-4b60-b43e-7efdb70ac175", name: "flemis", invitationCode: "", type: "", goal: 115, goalMeasure: "unity", finished: false, ownerId: "", online: false, alreadyBegin: false, maxTeams: 2, createdAt: "", updatedAt: "", teams: [], owner: User(email: "tester@tester.com", name: "tester")))
//        
//        //when
//        self.sut.$serverResponse
//            .print("server response")
//            .dropFirst(2)
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                serverResponseExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        //when
//        self.sut.$challengesList
//            .print("challenge list")
//            .dropFirst()
//            .subscribe(on: DispatchQueue.global(qos: .userInitiated))
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .sink(receiveValue: { _ in
//                challengesListExpectation.fulfill()
//            })
//            .store(in: &cancellables)
//        
//        self.sut.deleteChallenge(by: "someWrongID")
//        wait(for: [challengesListExpectation, serverResponseExpectation], timeout: self.expTimeout)
//        
//        //then
//        XCTAssertEqual(self.sut.serverResponse, .internalError)
//        XCTAssertEqual(self.sut.challengesList.isEmpty, false)
//    }
//}
