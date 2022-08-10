//
//  HTTPResult.swift
//  Fiero
//
//  Created by Marina De Pazzi on 15/07/22.
//

import Foundation

enum HTTPResult<Item> {
    case success(Item)
    case created(Item)
    case failure(HTTPURLResponse, Data)
    
    var item: Item? {
        if case .success(let item) = self {
            return item
        }
        
        if case .created(let item) = self {
            return item
        }
        
        return nil
    }
    
    var statusCode: Int {
        switch self {
            case .success:
                return 200
            case .created:
                return 201
            case .failure(let httpUrlResponse, _):
                return httpUrlResponse.statusCode
        }
    }
}
