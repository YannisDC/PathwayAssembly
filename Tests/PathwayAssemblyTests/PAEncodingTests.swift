import XCTest
@testable import PathwayAssembly

final class PAEncodingTests: XCTestCase {

    func testSearchOrder() throws {
        XCTAssertEqual(PathwayAssembly.searchOrder(length: 2), [2])
        XCTAssertEqual(PathwayAssembly.searchOrder(length: 3), [2, 3])
        XCTAssertEqual(PathwayAssembly.searchOrder(length: 4), [4, 2, 3])
        XCTAssertEqual(PathwayAssembly.searchOrder(length: 5), [4, 5, 2, 3])
        XCTAssertEqual(PathwayAssembly.searchOrder(length: 6), [6, 4, 5, 2, 3])
    }

    func testOccurrences() throws {
        XCTAssertEqual("A".occurrences(of: ""), 0)
        XCTAssertEqual("".occurrences(of: "A"), 0)
        XCTAssertEqual("B".occurrences(of: "A"), 0)
        XCTAssertEqual("A".occurrences(of: "B"), 0)
        XCTAssertEqual("A".occurrences(of: "A"), 1)
        XCTAssertEqual("AA".occurrences(of: "A"), 2)
        XCTAssertEqual("AAA".occurrences(of: "AA"), 1)
        XCTAssertEqual("AAAA".occurrences(of: "AA"), 2)
        XCTAssertEqual("AABAA".occurrences(of: "AA"), 2)
        XCTAssertEqual("BABAABAA".occurrences(of: "AA"), 2)
        XCTAssertEqual("BAABAAABAA".occurrences(of: "AAA"), 1)
        XCTAssertEqual("BAABAAABAA".occurrences(of: "BAA"), 3)
    }

    func testSubPatterns() throws {
        XCTAssertEqual("".subpatterns(ofLength: 2), [String: Int]())
        XCTAssertEqual("AA".subpatterns(ofLength: 2), [String: Int]())
        XCTAssertEqual("ABBA".subpatterns(ofLength: 2), [String: Int]())
        XCTAssertEqual("AAAA".subpatterns(ofLength: 2), ["AA": 2])
        XCTAssertEqual("AABBAA".subpatterns(ofLength: 2), ["AA": 2])
        XCTAssertEqual("AABBAACBBAA".subpatterns(ofLength: 2), ["AA": 3, "BB": 2])
    }

    func testFindAllDuplicates() throws {
        XCTAssertEqual(PathwayAssembly.findAllDuplicatesIn(ST: ["0": "BAAAABBB"], forLength: 4, substitutionSymbols: ["z"]), [String:String]())
        XCTAssertEqual(PathwayAssembly.findAllDuplicatesIn(ST: ["0": "AAAAAAAA"], forLength: 4, substitutionSymbols: ["z"]), ["z": "AAAA"])
        XCTAssertEqual(PathwayAssembly.findAllDuplicatesIn(ST: ["0": "BAAAABBB"], forLength: 2, substitutionSymbols: ["z"]), ["z": "AA"])
        XCTAssertEqual(PathwayAssembly.findAllDuplicatesIn(ST: ["0": "BAAAABBBCBB"], forLength: 2, substitutionSymbols: ["y", "z"]), ["z": "AA", "y": "BB"])
        XCTAssertEqual(PathwayAssembly.findAllDuplicatesIn(ST: ["0": "BAAAABBBBAAAABBBB"], forLength: 8, substitutionSymbols: ["y", "z"]), ["z": "AAAABBBB", "y": "BAAAABBB"])
        XCTAssertEqual(PathwayAssembly.findAllDuplicatesIn(ST: ["0": "BAAAABBBBAAAABBBBDCCCCCCCCECCCCCCCC"], forLength: 8, substitutionSymbols: ["x", "y", "z"]), ["z": "AAAABBBB", "y": "BAAAABBB", "x": "CCCCCCCC"])
    }

    func testDigDeeper() throws {
        XCTAssertEqual(PathwayAssembly.depthSearch(str: "CCCCCCCC"), ["4": 1, "2": 1])
        XCTAssertEqual(PathwayAssembly.depthSearch(str: "AAAABBBB"), ["4": 0, "2": 2])
        XCTAssertEqual(PathwayAssembly.depthSearch(str: "BAAAABBB"), ["4": 0, "2": 1])
    }

    func testBuild() throws {
        XCTAssertEqual(PathwayAssembly.buildST(from: "ABRACADABRA"), [
            "0" : "zCADz",
            "z" : "ABRA"
        ])
    }

    func testHammer() throws {
//        XCTAssertEqual(PathwayAssembly.hammer(string: "ABRACADABRA"), 7)
        XCTAssertEqual(PathwayAssembly.hammer(string: "BAAAABBBBAAAABBBBDCCCCCCCCECCCCCCCC"), 14)
    }

    func testZeroDimension() throws {
//        XCTAssertEqual(PathwayAssembly.hammer(string: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"), 10)
//        XCTAssertEqual(PathwayAssembly.hammer(string: "ABBADBAAB"), 6)
        print(PathwayAssembly.buildST(from: "ABBADBAAB"))
    }

//    func testBuildIt() throws {
//        XCTAssertEqual(PathwayAssembly.buildST(from: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"), ["r": "AA", "z": "yyr", "v": "rr", "x": "ww", "y": "xxr", "0": "zzr", "w": "vv"])
//    }
}
