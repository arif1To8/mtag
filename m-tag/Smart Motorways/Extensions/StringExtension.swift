//
//  StringExtension.swift
//  AddMee
//
//  Created by Abdul Wahab on 11/04/2021.
//

import Foundation

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func isValidEmail() -> Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    func replacePattern(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return self
        }
    }
    
    var fixZeroWidthSpace: String {
        addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacePattern(pattern: "%E2%80%8B", replaceWith: "") ?? ""
    }
    
    func isValidCnic() -> Bool {
        if self == "" {
            return false
        }
        if self.count != 15 {
            return false
        }
        var mutated = self
        mutated = mutated.replacingOccurrences(of: "-", with: "")
        mutated = mutated.replacingOccurrences(of: "-", with: "")
        if !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: mutated)) {
            return false
        }
        return true
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
}
