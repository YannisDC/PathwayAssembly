//
//  Int+Extensions 2.swift
//  
//
//  Created by Yannis De Cleene on 27/04/2022.
//

import Foundation

extension Int {
    /// Returns array of recursive halving
    ///
    /// 11.halves => []
    /// 10.halves => [5]
    /// 16.halves => [8, 4, 2]
    var halves: [Int] {
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
