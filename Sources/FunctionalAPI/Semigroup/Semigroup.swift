
precedencegroup SemigroupPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator <>: SemigroupPrecedence

/// A semigroup is a type that supports a binary operation (`combine`) that is
/// associative.
///
/// Some types can have more than one valid implementation of the `Semigroup`
/// protocol, and the witness passed to the `combine` method determines which
/// implementation to use.
public protocol Semigroup {

    /// Combines two values of the same type using the semigroup operation.
    ///
    /// - Parameters:
    ///   - a: The first value to combine.
    ///   - b: The second value to combine.
    ///   - Returns: The result of combining the two values using the semigroup operation.
    static func combine(_ a: Self, _ b: Self) -> Self

    static func <>(lhs: Self, rhs: Self) -> Self
}

public extension Semigroup {
    static func <>(lhs: Self, rhs: Self) -> Self {
        lhs.combine(rhs)
    }

    func combine(_ other: Self) -> Self {
        Self.combine(self, other)
    }
}
