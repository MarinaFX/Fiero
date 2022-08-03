//
//  QCType.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

enum QCType: CustomStringConvertible, Equatable {
    case amount
    case byTime(String?)
    case bestOf
    
    var description: String {
        switch self {
            case .amount:
                return "amount"
            case .byTime(_):
                return "byTime"
            case .bestOf:
                return "bestof"
        }
    }
}
