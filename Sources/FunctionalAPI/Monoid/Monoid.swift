
public protocol Monoid: Semigroup {
    static var empty: Self { get }
}

extension Monoid {
    public static func combine(_ a: Self, _ b: Self) -> Self { a <> b }
}

// MARK: -

public extension Monoid {
    static func mappend(_ a: Self, _ b: Self) -> Self {
        Self.combine(a, b)
    }

    static func mconcat<S: Sequence>(_ sequence: S) -> Self where S.Element == Self {
        return sequence.reduce(Self.empty, Self.combine)
    }
}
