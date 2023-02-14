
precedencegroup SemigroupPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator <>: SemigroupPrecedence


/// Type that has an operation, often called combine or append,
/// that takes two values of the same type and returns another
/// value of the same type. This operation must be associative,
/// meaning that the order in which the values are combined
/// does not matter.
public protocol Semigroup {
    /// This method should combine the two values according to some associative operation.
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
