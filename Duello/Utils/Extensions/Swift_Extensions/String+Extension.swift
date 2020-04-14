//
//  String+Extension.swift
//  Duello
//
//  Created by Darius Dresp on 3/4/20.
//  Copyright © 2020 Darius Dresp. All rights reserved.
//

import Foundation

extension String {
    
    func isValidEmailAddress() -> Bool {
        if self.count > 0 {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluate(with: self)
        } else { return false }
    }
    
    func isValidPassword() -> Bool {
        return self.count > 6
    }
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.lowercased().hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func isValidInstagramLink() -> Bool {
        if let _ = self.toInstagramLink() {
            return true
        } else {
            return false
        }
    }
    
    func toInstagramLink() -> String? {
        if self.count == 0 { return nil }
        var link = self
        
        if link.lowercased().hasPrefix("http://") {
            link = link.deletingPrefix("http://")
        }
        if !link.lowercased().hasPrefix("https://") && !link.lowercased().hasPrefix("www.") {
            link = "https://www." + link
        } else if !link.lowercased().hasPrefix("https://") {
            link = "https://" + link
        }
        
        guard link.lowercased().hasPrefix(instagramPrefix) else { return nil }
        return link
        
    }
    
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while ranges.last.map({ $0.upperBound < self.endIndex }) ?? true,
            let range = self.range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale)
        {
            ranges.append(range)
        }
        return ranges
    }
    
}

extension String: DatabaseConvertibleType {
    
    func toStringValue() -> String {
        return self
    }
    
}
