
extension String: Monoid {
    public static var empty: String { "" }
}

extension Array: Monoid {
    public static var empty: [Element] { [] }

    func concat() -> Element where Element: Monoid {
        reduce(Element.empty, (<>))
    }
}
