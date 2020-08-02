import XCTest
@testable import FunctionalAPI

import SnapshotTesting

let aa = [1,2]
let bb = ["a", "b"]
let cc = [1.1, 2.2, 3.3]
let dd = ["🍏", "🌟", "💩", "🍣"]
let empty: [Any] = []

final class ProductTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        SnapshotTesting.record = false
    }

    func test_products() {

        assertSnapshot(
            matching: product(aa, bb).map(String.init(describing:)).joined(separator: "\n"),
            as: .lines,
            named: "aa X bb"
        )
        
        assertSnapshot(
            matching: product(bb, aa).map(String.init(describing:)).joined(separator: "\n"),
            as: .description,
            named: "bb X aa"
        )
        
        assertSnapshot(
            matching: product(aa, bb, cc).map(String.init(describing:)).joined(separator: "\n"),
            as: .description,
            named: "aa X bb X cc"
        )
        
        assertSnapshot(
            matching: product(cc, aa, bb).map(String.init(describing:)).joined(separator: "\n"),
            as: .description,
            named: "cc X aa X bb"
        )
        
        assertSnapshot(
            matching: product(cc, bb, aa).map(String.init(describing:)).joined(separator: "\n"),
            as: .description,
            named: "cc X bb X aa"
        )
        
        assertSnapshot(
            matching: product(aa, bb, cc, dd).map(String.init(describing:)).joined(separator: "\n"),
            as: .description,
            named: "cc X bb X cc X dd"
        )
    }
    
    func test_productWithEmpty() {
        assertSnapshot(
            matching: product(aa, empty),
            as: .description,
            named: "aa x empty")
        
        assertSnapshot(
            matching: product(empty, aa),
            as: .description,
            named: "empty x aa")
        
        assertSnapshot(
            matching: product(aa, bb, empty),
            as: .description,
            named: "aa x bb x empty")
        
        assertSnapshot(
            matching: product(empty, aa, bb),
            as: .description,
            named: "empty x aa x bb")
        
        assertSnapshot(
            matching: product(aa, empty, bb),
            as: .description,
            named: "aa x empty x bb")
    }
}
