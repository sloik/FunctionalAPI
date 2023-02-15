import XCTest

import FunctionalAPI

class MonoidLawTests: XCTestCase {

    /// Test the monoid laws for a given type that conforms to the `Monoid` protocol.
    ///
    /// - Parameters:
    ///   - element: The instance of the type that conforms to the `Monoid` protocol that you want to test.
    /// - Returns: Returns `true` if all the monoid laws pass for the given type, and `false` otherwise.
    ///
    /// Monoid laws:
    /// - Left identity: `mappend mempty x == x`
    /// - Right identity: `mappend x mempty == x`
    /// - Associativity: `mappend x (mappend y z) == mappend (mappend x y) z`
    func testMonoidLaws<M: Monoid & Equatable>(element: M) {
        // test left identity
        let a = element
        let left = M.combine(M.empty, a)
        XCTAssertEqual(left, a, "Left identity law failed for \(a)")

        // test right identity
        let b = element
        let right = M.combine(b, M.empty)
        XCTAssertEqual(right, b, "Right identity law failed for \(b)")

        // test associativity
        let c = element
        let associativity1 = M.combine(a, M.combine(b, c))
        let associativity2 = M.combine(M.combine(a, b), c)
        XCTAssertEqual(associativity1, associativity2, "Associativity law failed for \(a), \(b), \(c)")
    }

    func test_Array() {
        testMonoidLaws(element: [42])
    }

    func test_String() {
        testMonoidLaws(element: "lorem")
    }
}
