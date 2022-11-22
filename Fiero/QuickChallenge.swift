//
//  QuickChallenge.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation
import SwiftUI

struct QuickChallenge: Decodable, Encodable, Equatable, Identifiable, Hashable {
    
    var id: String
    var name: String
    var invitationCode: String?
    var type: String
    var goal: Int
    var goalMeasure: String
    var finished: Bool
    var ownerId: String
    var online: Bool
    var alreadyBegin: Bool
    var maxTeams: Int
    var createdAt: String
    var updatedAt: String
    var teams: [Team]
    var owner: User
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(ownerId)
    }
    
    func getRanking() -> [Team] {
        return self.teams.sorted(by: { $0.getTotalScore() > $1.getTotalScore() })
    }
    
    func getTeamPositionAtRanking(teamId: String) -> Int {
        let orderedTeams: [Team] = self.getRanking()
        for index in 0..<orderedTeams.count {
            if(orderedTeams[index].id == teamId) {
                return index
            }
        }
        return -1
    }
    
    func getTeamIndexById(teamId: String) -> Int {
        for index in 0..<teams.count {
            if teams[index].id == teamId {
                return index
            }
        }
        return -1
    }
    
    func getTeamIdByMemberId(memberUserId: String) -> String {
        for team in teams {
            guard let members = team.members else { return "" }
            for member in members {
                if member.userId == memberUserId {
                    return team.id
                }
            }
        }
        return ""
    }
    
    func getMemberIdByUserId(userId: String) -> String {
        for team in teams {
            guard let members = team.members else { return "" }
            for member in members {
                if member.userId == userId {
                    return member.id
                }
            }
        }
        return ""
    }
    
    static func == (lhs: QuickChallenge, rhs: QuickChallenge) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.ownerId == rhs.ownerId
    }
    
    var createdAtDate: Date {
        let correctTimestamp = "\(createdAt.dropLast())+0300"
        return Self.dateFormatter.date(from: correctTimestamp) ?? Date()
    }
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
}
