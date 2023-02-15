extension Int: Semigroup {

    /// This implementation is biased to addition.
    public static func combine(_ a: Int, _ b: Int) -> Int {
        addition(a,b)
    }

    // Addition witness
    public static let addition: (Int, Int) -> Int = (+)

    // Multiplication witness
    public static let multiplication: (Int, Int) -> Int = (*)
}

extension Swift.Array: Semigroup {
    public static func combine(_ a: Array<Element>, _ b: Array<Element>) -> Array<Element> {
        a + b
    }

    func concat() -> Element? where Element: Semigroup {
        guard let start = first else { return .none }

        return self[1...].reduce(start, (<>))
    }
}

extension String: Semigroup {
    public static func combine(_ a: String, _ b: String) -> String {
        a + b
    }
}
