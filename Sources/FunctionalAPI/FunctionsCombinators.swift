
import Foundation
import EitherSwift

// MARK: - Combinators

public func compose<A,B,C>(
    _ f: @escaping (A) -> B,
    _ g: @escaping (B) -> C
) -> (A) -> C {
    return { a in
        let b = f(a)
        let c = g(b)
        return c
    }
}

public func curry<A,B,C>(_ f: @escaping (A,B) -> (C)) -> (A) -> (B) -> C {
    return { a in
        return { b in
            return f(a,b)
        }
    }
}

public func uncurry<A,B,C>(_ f: @escaping (A) -> (B) -> C) -> (A,B) -> C {
    return { (a: A, b: B) in
        return f(a)(b)
    }
}

public func flip<A,B,C>(_ f: @escaping (A, B) -> C) -> (B, A) -> C {
    { b,a in f(a,b) }
}

public func thunk<A>(_ a: A) -> () -> A {
    return { a }
}

func zurry<A>(_ f: () -> A) -> A {
    f()
}

public func partial<A, B, T>(_ f: @escaping (A, B) -> T, _ a: A) -> (B) -> T {
    return { b in f(a, b) }
}

public func partial<A, B, C, T>(_ f: @escaping (A, B, C) -> T, _ a: A) -> (B) -> (C) -> T {
    return { b in { c in f(a, b, c) } }
}


// MARK: - KeyPath to Function

prefix operator ^

/// Changes KeyPath from `Root` to `Value` in to a function `(Root) -> Value`.
public prefix func ^<Root, Value>(
    _ kp: KeyPath<Root,Value>)
-> (Root) -> Value {
    return { root in root[keyPath: kp] }
}

// MARK: - Application

precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

/// Applys function `f` to value `x`.
public func |> <A, B>(x: A, f: (A) -> B) -> B {
    f(x)
}

// MARK: - FunctorialApplication or MAP
precedencegroup FunctorialApplication {
    associativity: left
}

infix operator <^>: FunctorialApplication
public func <^> <A, B>(_ a: A, _ f: @escaping (A) -> B) -> B {
    f(a)
}

public func <^> <A, B>(_ a: [A], _ f: @escaping (A) -> B) -> [B] {
    a.map(f)
}

public func <^> <A, B>(_ a: A?, _ f: @escaping (A) -> B) -> B? {
    a.map(f)
}

public func <^> <A,B, E: Error>(_ a: Result<A,E> , _ f: @escaping (A) -> B) -> Result<B,E> {
    a.map(f)
}

public func <^> <Left,Right,NewRight>(_ a: Either<Left,Right>, _ f: @escaping (Right) -> NewRight) -> Either<Left,NewRight> {
    a.map(f)
}

// MARK: -
precedencegroup ForwardComposition {
    higherThan: ForwardApplication
    associativity: right
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(_ f: @escaping (A) -> B, _ g: @escaping (B) -> C) -> (A) -> C {
    return { a in g( f(a) ) }
}




