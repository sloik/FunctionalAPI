import XCTest

import FunctionalAPI

class SemigroupLawTests: XCTestCase {

    /// Tests the associativity law for a given semigroup.
    ///
    /// The associativity law states that for any three values a, b, and c of a semigroup type S,
    /// the following equality holds:
    ///
    ///     (a <> b) <> c = a <> (b <> c)
    ///
    /// - Parameters:
    ///     - witness: A closure that takes two values of type S and returns their semigroup combination
    ///                using a specific operation.
    ///     - a: The first value to test.
    ///     - b: The second value to test.
    ///     - c: The third value to test.
    ///
    /// - Requires: The operation defined by the witness closure must be associative.
    ///
    /// - Note: This function raises an assertion if the associativity law fails for the given values and operation.
    func testAssociativityLaw<S: Semigroup & Equatable>(using witness: @escaping (S, S) -> S, a: S, b: S, c: S, file: StaticString = #file, line: UInt = #line) {
        let result1 = witness(witness(a, b), c)
        let result2 = witness(a, witness(b, c))

        print(result2)

        XCTAssertEqual(
            result1,
            result2,
            "The associativity law failed for values (\(a), \(b), \(c))",
            file: file,
            line: line
        )
    }


    func test_Int() {
        testAssociativityLaw(using: Int.addition, a: 5, b: 10, c: 15)
        testAssociativityLaw(using: Int.multiplication, a: 5, b: 10, c: 15)
    }
}
