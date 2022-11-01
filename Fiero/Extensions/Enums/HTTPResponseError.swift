//
//  HTTPResponseError.swift
//  Fiero
//
//  Created by Marina De Pazzi on 31/10/22.
//

import Foundation

enum HTTPResponseError: Int, Error {
    case notFound = 404
    case internalServerError = 500
    case unauthorized = 403
    case success = 200
    case created = 201
    case conflict = 409
    case unknown = -1
}
