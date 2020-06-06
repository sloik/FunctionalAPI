/*:
 # Inspiration
 
 https://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Either.html
 */

import Foundation
import OptionalAPI

public enum Either<Left, Right> {
    case left(Left)
    case right(Right)
}

// MARK: - Computed Properties

public extension Either {
    
    /// `true` when is `left`
    var isLeft: Bool {
        switch self {
        case .left: return true
            
        default: return false
        }
    }
    
    /// `true` when is `left`
    var isRight: Bool {
        switch self {
        case .right: return true
            
        default: return false
        }
    }
    
    var right: Right? {
        switch self {
        case .right(let r): return r
        default: return .none
        }
    }
    
    var left: Left? {
        switch self {
        case .left(let l): return l
        default: return .none
        }
    }
    
    
    /// Return the contents of a Left-value or a default value otherwise.
    /// - Parameter defaultLeft: Value of type `Left` to be returned when self is `Right`
    func fromLeft(_ defaultLeft: Left) -> Left { left.or(defaultLeft) }
    
    /// Return the contents of a Right-value or a default value otherwise.
    /// - Parameter defaultLeft: Value of type `Right` to be returned when self is `Left`
    func fromRight(_ defaultRight: Right) -> Right { right.or(defaultRight)}
    
    // Right is a bit special in this type 🤓
    var toOptional: Right? { right }
    
    var toResult: Result<Right?, Never> {
        .success(right)
    }
}

// MARK: - Never

public extension Either where Left == Never {
    var right: Right {
        switch self {
        case .right(let r): return r
        }
    }
    
    var toResult: Result<Right, Never> {
        .success(right)
    }
}

public extension Either where Left == Error {
    var toResult: Result<Right, Left> {
        switch self {
        case .left(let l):
            return .failure(l)
            
        case .right(let r):
            return .success(r)
        }
    }
}

public extension Either where Right == Never, Left == Error {
    var left: Left {
        switch self {
        case .left(let l): return l
        }
    }
    
    var toResult: Result<Never, Left> {
        .failure(left)
    }
}

// MARK: - Equatable

extension Either: Equatable where Left: Equatable, Right: Equatable {}

// MARK: - Maps
public extension Either {
    func map<R>(_ transform: (Right) -> R) -> Either<Left,R> {
        switch self {
        case .right(let r):
            return .right( transform( r ) )
            
        case .left(let l):
            return .left( l )
        }
    }

    func mapRight<R>(_ transform: (Right) -> R) -> Either<Left, R> {
        map(transform)
    }

    func mapLeft<L>(_ transform: (Left) -> L) -> Either<L, Right> {
        switch self {
        case .right(let r):
            return .right( r )

        case .left(let l):
            return  .left( transform(l) )
        }
    }

    func mapBi<L,R>( _  leftTransform:  (Left) -> L,
                     _ rightTransform: (Right) -> R)
        -> Either<L, R> {
            switch self {
            case .left (let l): return  Either<L, R>.left ( leftTransform(l))
            case .right(let r): return  Either<L, R>.right(rightTransform(r))
            }
    }
}

public extension Either {
    func flatMap<R>(_ transform: (Right) -> Either<Left, R> ) -> Either<Left, R> {
        switch self {
        case .left(let l) : return Either<Left, R>.left(l)
        case .right(let r): return transform(r)
        }
    }
    
    func flatMapRight<R>(_ transform: (Right) -> Either<Left, R>) -> Either<Left, R> {
        flatMap(transform)
    }
    
    func flatMapLeft<L>(_ transform: (Left) -> Either<L, Right>) -> Either<L, Right> {
        switch self {
        case .left(let l) : return transform(l)
        case .right(let r): return Either<L, Right>.right(r)
        }
    }
}

// MARK: - Free Maps

public func map<NewR,L,R>(
    _ either: Either<L,R>,
    _ transform: (R) -> NewR)
    -> Either<L,NewR> {
        either.map(transform)
}

public func mapRight<NewR,L,R>(
    _ either: Either<L,R>,
    _ transform: (R) -> NewR)
    -> Either<L,NewR> {
        map(either, transform)
}

public func mapLeft<NewL,L,R>(
    _ either: Either<L,R>,
    _ transform: (L) -> NewL)
    -> Either<NewL,R> {
        either.mapLeft(transform)
}

public func mapBi<NewL, NewR, L,R>(
    _ either: Either<L,R>,
    _ leftTransform: (L) -> NewL,
    _ rightTransform: (R) -> NewR)
    -> Either<NewL,NewR> {
        either.mapBi(leftTransform, rightTransform)
}

public func flatMap<T,L,R>(
    _ either: Either<L,R>,
    _ transform: (R) -> Either<L,T>)
    -> Either<L,T> {
        either.flatMap(transform)
}

public func flatMapRight<NewR,L,R>(
    _ either: Either<L,R>,
    _ transform: (R) -> Either<L,NewR>)
    -> Either<L,NewR> {
        either.flatMap(transform)
}

public func flatMapLeft<NewL,L,R>(
    _ either: Either<L,R>,
    _ transform: (L) -> Either<NewL,R>)
    -> Either<NewL,R> {
        either.flatMapLeft(transform)
}

// MARK: - Utils
// Inspired from: http://hackage.haskell.org/package/base-4.14.0.0/docs/Data-Either.html

public func either<L,R,T>(
    _  leftTransform: @escaping (L) -> T,
    _ rightTransform: @escaping (R) -> T) -> (Either<L,R>) -> T {
    return { either in
        switch either {
        case .left(let l) : return  leftTransform(l)
        case .right(let r): return rightTransform(r)
        }
    }
}

public func lefts<L,R>(_ eithers: [Either<L,R>] ) -> [L] {
    eithers.compactMap(\.left)
}

public func rights<L,R>(_ eithers: [Either<L,R>] ) -> [R] {
    eithers.compactMap(\.right)
}

public func partitionEithers<L,R>(_ eithers: [Either<L,R>]) -> ([L], [R]) {
    eithers
        .reduce(([L](), [R]())) { (accumulator, either) in
            let (lefts, rights) = accumulator
            
            switch either {
            case .left(let l):
                return (lefts + [l], rights)
                
            case .right(let r):
                return (lefts, rights + [r])
            }
    }
}

