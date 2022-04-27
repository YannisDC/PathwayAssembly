//
//  PAAnalysisTests.swift
//  
//
//  Created by Yannis De Cleene on 18/03/2022.
//

import XCTest
@testable import PathwayAssembly

final class PAAnalysisTests: XCTestCase {

    func testUpdateCallTable() throws {
        XCTAssertEqual(PathwayAssembly.updateCallTable(old: ["B": 0], toAdd: ["A": 0]), ["B": 0, "A": 0])
        XCTAssertEqual(PathwayAssembly.updateCallTable(old: ["B": 0, "A": 0], toAdd: ["A": 1]), ["B": 0, "A": 1])
        XCTAssertEqual(PathwayAssembly.updateCallTable(old: ["B": 0, "A": 1], toAdd: ["A": 0]), ["B": 0, "A": 1])
    }

    func testFilter() throws {
        let emptyCT = [String: Int]()

        XCTAssertEqual(PathwayAssembly.filter(level: 0, VT: ["B": 0], CT: emptyCT), ["B": 0])
        XCTAssertEqual(PathwayAssembly.filter(level: 0, VT: ["B": 0, "A": 0], CT: emptyCT), ["B": 0, "A": 0])
        XCTAssertEqual(PathwayAssembly.filter(level: 0, VT: ["B": 5, "A": 2], CT: ["B": 1]), ["B": 5, "A": 2])
        XCTAssertEqual(PathwayAssembly.filter(level: 0, VT: ["B": 5, "A": 2], CT: ["B": 2]), ["B": 0, "A": 2])
        XCTAssertEqual(PathwayAssembly.filter(level: 1, VT: ["A": 0, "x": 1, "B": 0], CT: ["x": 1]), ["A": 0, "x": 1, "B": 0])
    }

    func testResymbolication() throws {
        XCTAssertEqual(PathwayAssembly.resymbolicate(ST: ["0": "BAAACDACAA"], symbol: "0", match: "AA", newSymbol: "z"), ["0": "BzACDACz", "z": "AA"])
        XCTAssertEqual(PathwayAssembly.resymbolicate(ST: ["0": "CDCD"], symbol: "0", match: "CD", newSymbol: "y"), ["0": "yy", "y": "CD"])
        XCTAssertEqual(PathwayAssembly.resymbolicate(ST: ["0": "AAAA"], symbol: "0", match: "AA", newSymbol: "x"), ["0": "xx", "x": "AA"])
        XCTAssertEqual(PathwayAssembly.resymbolicate(ST: ["0": "BAAACDACAA", "x": "EE"], symbol: "0", match: "AA", newSymbol: "z"), ["0": "BzACDACz", "z": "AA", "x": "EE"])
    }

    func testScore() throws {
        let emptyValues = [String : Int]()

        XCTAssertEqual(PathwayAssembly.score(word: "A", values: emptyValues), 0)
        XCTAssertEqual(PathwayAssembly.score(word: "A", values: ["A" : 1]), 1)
        XCTAssertEqual(PathwayAssembly.score(word: "AA", values: ["A" : 1]), 2)
        XCTAssertEqual(PathwayAssembly.score(word: "AB", values: emptyValues), 1)
        XCTAssertEqual(PathwayAssembly.score(word: "ABC", values: emptyValues), 2)
        XCTAssertEqual(PathwayAssembly.score(word: "ABC", values: ["A" : 1]), 3)
        XCTAssertEqual(PathwayAssembly.score(word: "ABCCC", values: emptyValues), 4)
        XCTAssertEqual(PathwayAssembly.score(word: "ABC", values: ["A" : 2]), 4)
        XCTAssertEqual(PathwayAssembly.score(word: "AB", values: ["A" : 2, "B" : 2]), 5)
        XCTAssertEqual(PathwayAssembly.score(word: "ABC", values: ["A" : 2, "C" : 1]), 5)
        XCTAssertEqual(PathwayAssembly.score(word: "AAB", values: ["A" : 2, "B" : 2]), 6)
        XCTAssertEqual(PathwayAssembly.score(word: "ABAC", values: ["A" : 2, "C" : 1]), 6)
        XCTAssertEqual(PathwayAssembly.score(word: "ABACD", values: ["A" : 2, "C" : 1]), 7)
    }

    func testComplexity() throws {
        let ST = [
            "0" : "Bxzvv",
            "z" : "xx",
            "y" : "ww",
            "x" : "AA",
            "w" : "CD",
            "v" : "zy"
        ]

        XCTAssertEqual(PathwayAssembly.complexity(ST: ST, root: "0"), 9)

        XCTAssertEqual(PathwayAssembly.complexity(ST: [ "0" : "xy",
                                                        "z" : "yy",
                                                        "y" : "AA",
                                                        "x" : "zz" ]
                                                  , root: "0"), 4)
    }

    func testMagic() throws {
        let ST = [
            "0" : "zCADz",
            "z" : "ABRA"
        ]

        XCTAssertEqual(PathwayAssembly.complexity(ST: ST, root: "0"), 7)
    }
}
