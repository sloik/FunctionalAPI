
extension String: Monoid {
    public static var empty: String { "" }
}

extension Array: Monoid {
    public static var empty: [Element] { [] }
}
