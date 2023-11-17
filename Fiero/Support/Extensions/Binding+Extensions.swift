//
//  Binding+Extensions.swift
//  Fiero
//
//  Created by Marina De Pazzi on 15/11/22.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
