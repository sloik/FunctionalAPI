

// functor protocol
public protocol Functor<A> {
    associatedtype A

    func fmap<B>(_ f: @escaping (A) -> B) -> any Functor<B>
}

// MARK: - 

extension Array: Functor {
    public typealias A = Element

    public func fmap<B>(_ f: @escaping (A) -> B) -> any Functor<B> {
        map( f )
    }
}

extension Optional: Functor {
    public typealias A = Wrapped

    public func fmap<B>(_ f: @escaping (Wrapped) -> B) -> any Functor<B> {
        map( f )
    }
}
