//
//  MockKeyValueStorage.swift
//  FieroTests
//
//  Created by Marina De Pazzi on 08/08/22.
//

import Foundation
@testable import Fiero

class MockKeyValueStorage: KeyValueStorage {
    var dictionary: [String: Any]
    
    init (dictionary: [String: Any]) {
        self.dictionary = dictionary
    }
    
    func string(forKey defaultName: String) -> String? {
        return dictionary[defaultName] as? String
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        self.dictionary[defaultName] = value
    }
}
