import Darwin
class Substitution {
    static let shared = Substitution()

    // This would be way more expandable if I just used tokens like <1>, <2> and so on instead of z, y
    var symbols = [String]()
    var dummySymbols = [String]()

    init() {
        let alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        symbols = alphabet
        dummySymbols = alphabet
    }
}

public struct PathwayAssembly {
    public private(set) var text = "Hello, World!"

    public init() {}

    // MARK: - Creating the symbol table

    /*
     Constructs the optimal order of the size of "duplicate sieves" to use.
     [ ... , 8, 9, 6, 7, 4, 5, 2, 3 ]

     */
    static public func searchOrder(length: Int) -> [Int] {
        if length == 2 { return [2] }
        let arr = Array((2...length).map { $0 }.reversed())
        let start = (length % 2 == 0) ? 1 : 0
        var newArr = arr

        for i in stride(from: start, to: arr.count-1, by: 2) {
            newArr[i] = arr[i+1]
            newArr[i+1] = arr[i]
        }
        return newArr
    }

    static public func resymbolicate(ST: [String: String], symbol: String, match: String, newSymbol: String) -> [String: String] {
        var newST = ST
        guard let wordToResymbolicate = ST[symbol] else {
            return newST
        }
        let resymbolicatedWord = wordToResymbolicate.substitute(occurence: match, symbol: newSymbol)
        newST[symbol] = resymbolicatedWord
        newST[newSymbol] = match
        return newST
    }

    static public func depthSearch(str: String) -> [String: Int] {
        let length = str.count
        var tree = [String: Int]()
        for x in length.halves {
            let dups = findAllDuplicatesIn(ST: ["0": str], forLength: x, substitutionSymbols: Substitution.shared.dummySymbols)
            // Throwing away the duplicates is not really efficient but it saves memory, I guess
            tree[String(x)] = dups?.count ?? 0
        }
        return tree
    }

    static public func sortDuplicateTree(branches: [String]) -> [String: Int] {
        var unsortedBranches = [String: Int]()
        var sortedBranches = [String: Int]()

        branches.forEach({ duplicate in
            let branch = depthSearch(str: duplicate)
            unsortedBranches[duplicate] = Int(branchScore(branch: branch))
        })

        unsortedBranches.forEach { sortedBranches[$0.key] = $0.value }
        return sortedBranches
    }

    static public func branchScore(branch: [String: Int]) -> Double {
        var score: Double = 0.0
        let sortedBranches = branch.sorted(by: { $0.key < $1.key })
        for (i, occ) in sortedBranches.enumerated() {
            score += pow(1000, Double(i+1)) * Double(occ.value)
        }
        return score
    }

    static public func buildST(from rootString: String) -> [String: String] {

        let maxLength = rootString.count/2
        let searchOrderArray = searchOrder(length: maxLength)

        var newST = ["0": rootString]

        for size in searchOrderArray {
            guard let duplicateBranches = findAllDuplicatesIn(ST: newST, forLength: size, substitutionSymbols: Substitution.shared.dummySymbols) else { continue }
            let resymbolicateOrder = sortDuplicateTree(branches: duplicateBranches.map { $0.value }).sorted(by: { $0.value > $1.value })
            guard !resymbolicateOrder.isEmpty else { continue }

            for word in resymbolicateOrder {
                let ST = newST
                var newSymbol = String()
                for register in ST {
                    if register.value.contains(word.key) {
                        newSymbol = Substitution.shared.symbols.popLast()!
                    }
                }
                if newSymbol.isEmpty {
                    continue
                }

                for register in ST {
                    newST = resymbolicate(ST: newST, symbol: register.key, match: word.key, newSymbol: newSymbol)
                }
            }
        }

        return newST
    }

    static public func findAllDuplicatesIn(ST: [String: String], forLength length: Int, substitutionSymbols: [String]) -> [String: String]? {
        var allSubsOfLenthX = [String]()
        var substitutions = substitutionSymbols

        // for every word that contains the sub do a replacement with the substitutionSymbol
        for register in ST {
            let subs = register.value.subpatterns(ofLength: length).sorted { $0.value > $1.value }
            for sub in subs {
                allSubsOfLenthX.append(sub.key)
            }
        }

        // TODO: Maybe improve sorting
        let RT = allSubsOfLenthX.sorted().map { sub -> [String: String] in
            let substitutionSymbol = substitutions.popLast()!
            return [substitutionSymbol: sub]
        }

        var arr = [String: String]()
        for (key, value) in RT.reduce([], +) {
            arr[key] = value
        }

        return arr
    }

    // MARK: - Analyzing the symbol table

    static public func score(word: String, values: [String: Int]) -> Int {
        let sumOfValues = Set(word).reduce(0, { pr, symbol in
            pr + (values[String(symbol)] ?? 0)
        })

        // When splitting up we will never have words of size 1
        let connections = word.count - 1

        return sumOfValues + connections
    }

    static public func filter(level: Int, VT: [String: Int], CT: [String: Int]) -> [String: Int] {
        var filteredVT = VT
        for item in VT {
            for call in CT {
                if call.key == item.key && (call.value - level) > 1 { // has been called before
                    filteredVT[item.key] = 0
                }
            }
        }
        return filteredVT
    }

    static public func updateCallTable(old: [String: Int], toAdd: [String: Int]) -> [String: Int] {
        var newDict = old
        for item in toAdd {
            if let oldValue = old[item.key] {
                if item.value > oldValue {
                    newDict[item.key] = item.value
                }
            } else {
                newDict[item.key] = item.value
            }
        }
        return newDict
    }

    static public func complexity(ST: [String: String], root: String) -> Int {
        var VT = [String: Int]()

        guard ST[root] != nil else {
            return 0
        }

        func lookup(symbol: String, level: Int) -> (Int, [String: Int]) {
            var CT = [String: Int]() // Call Table

            print("\(level) => \(symbol)")

            if let value = VT[symbol] {
                print("VT")
                CT = updateCallTable(old: CT, toAdd: [symbol: level])
                print("VT=\(VT) and CT=\(CT)")
                return (value, CT)
            }
            print("!VT")

            guard let word = ST[symbol] else {
                print("!ST")
                print("0 -> VT")
                print("\(level) -> CT")
                VT[symbol] = 0
                let value = 0
                CT = updateCallTable(old: CT, toAdd: [symbol: level])
                print("VT=\(VT) and CT=\(CT)")
                return (value, CT)
            }

            print("ST")

            for letter in word {
                let result = lookup(symbol: String(letter), level: level + 1)
                CT = updateCallTable(old: CT, toAdd: result.1)
            }

            print("VT=\(VT) and CT=\(CT) on LEVEL=\(level)")
            let filteredVT = filter(level: level, VT: VT, CT: CT)
            print("Filtered = \(filteredVT)")

            let wordScore = score(word: word, values: filteredVT)
            CT = updateCallTable(old: CT, toAdd: [symbol: level])
            VT[symbol] = wordScore
            print("VT=\(VT) and CT=\(CT)")
            return (wordScore, CT)
        }

        return lookup(symbol: root, level: -1).0
    }

    static public func hammer(string: String) -> Int {
        let ST = PathwayAssembly.buildST(from: string)
        let assemblyNumber = PathwayAssembly.complexity(ST: ST, root: "0")
        return assemblyNumber
    }
}
