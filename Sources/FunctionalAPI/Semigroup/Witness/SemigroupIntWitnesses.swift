extension Int: Semigroup {

    /// This implementation is biased to addition.
    public static func combine(_ a: Int, _ b: Int) -> Int {
        a + b
    }

    // Addition witness
    public static let addition: (Int, Int) -> Int = Int.combine(_:_:)

    // Multiplication witness
    public static let multiplication: (Int, Int) -> Int = (*)
}
