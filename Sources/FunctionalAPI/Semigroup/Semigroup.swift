
precedencegroup SemigroupPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator <>: SemigroupPrecedence

/// A semigroup is a type that supports a binary operation (`combine`) that is
/// associative.
///
/// An associative operation is an operation that can be applied
/// to three or more values in any order, and the result will always be the same.
/// In other words, if you have three values a, b, and c, then (a * b) * c will
/// always be equal to a * (b * c) if the operation * is associative. This property
/// is important in mathematics and computer science because it allows us to group
/// operations in different ways without changing the result.
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
}

public extension Semigroup {
    static func <>(lhs: Self, rhs: Self) -> Self {
        lhs.combine(rhs)
    }

    func combine(_ other: Self) -> Self {
        Self.combine(self, other)
    }
}
