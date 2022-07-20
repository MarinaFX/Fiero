//
//  QCType.swift
//  Fiero
//
//  Created by Marina De Pazzi on 20/07/22.
//

import Foundation

enum QCType: CustomStringConvertible, Equatable {
    case quickest
    case highest(String?)
    case bestOf
    
    var description: String {
        switch self {
            case .quickest:
                return "quickest"
            case .highest(_):
                return "highest"
            case .bestOf:
                return "bestof"
        }
    }
}
