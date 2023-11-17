//
//  String+Extensions.swift
//  Fiero
//
//  Created by Marina De Pazzi on 06/10/22.
//

import Foundation

extension String {
    public static func fromBase64(_ encoded: String) -> String? {
        if let data = Data.fromBase64(encoded) {
            return String(data: data, encoding: .utf8)
        }
        return nil;
    }
}
