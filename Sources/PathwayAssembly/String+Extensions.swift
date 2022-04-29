//
//  String+Extensions.swift
//  
//
//  Created by Yannis De Cleene on 17/03/2022.
//

import Foundation

extension String {
    /// Returns a string where all non-overlapping occurences are replaced by a given symbol.
    ///
    /// "AAABAAC".substitute(occurence: "AA", symbol: "z") => "zABzC"
    func substitute(occurence: String, symbol: String) -> String {
        var newString = self
        while newString.contains(occurence) {
            let firstHit = newString.range(of: occurence)!
            let substitutedString = newString.replacingCharacters(in: firstHit, with: symbol)
            newString = substitutedString
        }
        return newString
    }

    /// Returns repeating substrings of a string and the amount of (non-overlapping) occurences of the substring in the string.
    /// "AAABAAC".subpatterns(ofLength: 2) => ["AA": 2]
    func subpatterns(ofLength x: Int) -> [String: Int] {
        var duplicates = [String: Int]()

        guard self.count-x > 0 else {
            return [String: Int]()
        }

        for i in 0...self.count-x {
            let newString = String(self.substring(with: i..<x+i))
            let occurrences = self.occurrences(of: newString)
            if occurrences > 1 {
                duplicates[newString] = occurrences
            }
        }

        return duplicates
    }

    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }

    /// Returns the amount of non-overlapping occurences in a string
    /// We can go with non-overlapping since we use cutting approach
    /// so the biggest size repeating element would always win.
    func occurrences(of match: String) -> Int {
        let str = Array(self)
        let matchArr = Array(match)
        var matchPossition = 0
        var matchCounter = 0

        guard str.count > 0, matchArr.count > 0, str.count >= matchArr.count else {
            return 0
        }
        guard self != match else {
            return 1
        }

        for i in 0...str.count-1 {
            if str[i] == matchArr[matchPossition] {
                if matchPossition == matchArr.count - 1 {
                    matchCounter += 1
                    matchPossition = 0
                } else {
                    matchPossition += 1
                }
            } else {
                matchPossition = 0
            }
        }

        return matchCounter
    }
}
