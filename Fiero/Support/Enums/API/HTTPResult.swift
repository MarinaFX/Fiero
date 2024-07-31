//
//  HTTPResult.swift
//  Fiero
//
//  Created by Marina De Pazzi on 15/07/22.
//

import Foundation

enum HTTPResult<Item> {
    case success(Item, Int)
    case created(Item, Int)
    case failure(Item, Int)
    
    var item: Item? {
        if case .success(let item, _) = self {
            return item
        }
        
        if case .success(let item, let int) = self {
            return item
        }
        
        if case .failure(let item, _) = self {
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
            case .failure(let item, let statusCode):
                return statusCode
        }
    }
}
