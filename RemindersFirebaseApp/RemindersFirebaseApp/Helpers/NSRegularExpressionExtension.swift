//
//  NSRegularExpressionExtension.swift
//  RemindersFirebaseApp
//
//  Created by Arin Asawa on 3/24/21.
//

import Foundation
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    func matches(_ string: String) -> Bool {
           let range = NSRange(location: 0, length: string.utf16.count)
           return firstMatch(in: string, options: [], range: range) != nil
       }
}