//
//  File.swift
//  
//
//  Created by Yannis De Cleene on 17/03/2022.
//

import Foundation

extension String {
    func substitute(occurence: String, symbol: String) -> String {
        var newString = self
        while newString.contains(occurence) {
            let firstHit = newString.range(of: occurence)!
            let substitutedString = newString.replacingCharacters(in: firstHit, with: symbol)
            newString = substitutedString
        }
        return newString
    }

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

    // Non-overlapping
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

extension Int {
    func halves() -> [Int] {
        var halves = [Int]()

        func halve(of number: Int) {
            if (number % 2 == 1) || (number == 2) {
                return
            }
            let half = number / 2
            halves.append(half)
            halve(of: half)
        }

        halve(of: self)

        return halves
    }
}
