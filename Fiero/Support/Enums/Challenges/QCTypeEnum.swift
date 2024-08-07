//
//  QCTypeEnum.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

enum QCTypeEnum: CustomStringConvertible, Equatable {
    case amount
    case byTime(String = "seconds")
    case bestOf
    case volleyball
    case healthKit
    case truco
    
    var description: String {
        switch self {
            case .amount:
                return "amount"
            case .byTime(_):
                return "byTime"
            case .bestOf:
                return "bestof"
            case .volleyball:
                return "volleyball"
            case .healthKit:
                return "healthKit"
            case .truco:
                return "truco"
        }
    }
}
