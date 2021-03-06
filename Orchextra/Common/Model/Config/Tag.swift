//
//  Tag.swift
//  Orchextra
//
//  Created by Judith Medina on 18/08/2017.
//  Copyright © 2017 Gigigo Mobile Services S.L. All rights reserved.
//

import Foundation
import GIGLibrary

public class Tag: Codable {

    var prefix: String?
    var name: String?

    public init(prefix: String) {
        if self.validatePrefix(prefix) {
            self.prefix = prefix
        }
    }
    
    public init(prefix: String, name: String) {
        if self.validatePrefix(prefix) {
            self.prefix = prefix
        }
        
        if self.validateName(name) {
            self.name = name
        }
    }
    
    public class func parse(tagsList: [String]?) -> [Tag] {
        guard let tags = tagsList else {return [Tag]() }
        return tags.map(tag)
    }
    
    /// Create tag
    ///
    /// - Parameter string: string with tag format
    /// - Returns: tag
    class func tag(string: String) -> Tag {
        let splitTag = string.split(separator: ":")
        
        if let prefix = splitTag.first?.description,
            let name = splitTag.last?.description,
            splitTag.count == 2 {
            return Tag(prefix: prefix, name: name)
        } else {
            return Tag(prefix: string.description)
        }
    }
    
    /// String with the tag
    ///
    /// - Returns: tag or nil
    public func tag() -> String? {
        
        var tag: String?
        
        if let prefix = self.prefix,
            let name = self.name {
            tag = "\(prefix)::\(name)"
        
        } else if let prefix = self.prefix,
            (self.name == nil) {
            tag = "\(prefix)"
        }
        return tag
    }

    // MARK: - PRIVATE
    
    /*
     Name: (::|\\/|^_|^.{0,1}$)
     
     * Cant use :: (double colon)
     * Cant use / (slash)
     * Cant start with _
     * Must have minimum 2 characters
     */
    private func validateName(_ name: String) -> Bool {
        let regexString = "(::|\\/|^_|^.{0,1}$)"
        let matches = self.matchestTex(text: name, regexString: regexString)
        
        if matches > 0 {
            logWarn("Name does not comply with the rules: \(name)")
            return false
        }
        return true
    }
    
    /*
     
     Prefix: (::|/|^_(?!(s$|b$))|^[^_].{0}$)
     
     * Cant use :: (double colon)
     * Cant use / (slash)
     * Cant start with _ except _s|_b
     * Must have minimum 2 characters
     
     */
    private func validatePrefix(_ prefix: String) -> Bool {
        let regexString = "(::|/|^_(?!(s$|b$))|^[^_].{0}$)"
        let matches = self.matchestTex(text: prefix, regexString: regexString)
        
        if matches > 0 {
            logWarn("Prefix does not comply with the rules: \(prefix)")
            return false
        }
        return true
    }
    
    func matchestTex(text: String, regexString: String) -> Int {
        do {
            let regexp: NSRegularExpression = try NSRegularExpression(pattern: regexString)
            let matches = regexp.matches(in: text, options: [], range: text.nsrange)
            return matches.count
        } catch {
            return 0
        }
    }
}

extension Tag: Equatable {
    public static func == (lhs: Tag, rhs: Tag) -> Bool {
        if lhs.prefix == rhs.prefix,
            lhs.name == rhs.name {
            return true
        } else {
            return false
        }
    }
}

extension String {
    /// An `NSRange` that represents the full range of the string.
    var nsrange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }
    
    /// Returns a substring with the given `NSRange`,
    /// or `nil` if the range can't be converted.
    func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange, in: self) else { return nil }
        return String(self[range])
    }
    
    /// Returns a range equivalent to the given `NSRange`,
    /// or `nil` if the range can't be converted.
//    func range(from nsrange: NSRange) -> Range<Index>? {
//        guard let range = nsrange.toRange() else { return nil }
//        let utf16Start = UTF16Index(range.lowerBound)
//        let utf16End = UTF16Index(range.upperBound)
//
//        guard let start = Index(utf16Start, within: self),
//            let end = Index(utf16End, within: self)
//            else { return nil }
//
//        return start..<end
//    }

    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self)
            else { return nil }
        return from ..< to
    }
}
