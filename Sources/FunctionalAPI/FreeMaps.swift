
import Foundation

// MARK: - Free map on Array
public func map<A,B>(_ a: [A], _ f: (A) -> B) -> [B] {
    a.map(f)
}

public func flatMap<A,B>(_ a: [A], _ f: (A) -> [B]) -> [B] {
    a.flatMap(f)
}

public func compactMap<A,B>(_ a: [A], _ f: (A) -> B?) -> [B] {
    a.compactMap(f)
}

// MARK: - Map on Result
public func map<A,B>(_ a: Result<A,Error> , _ f: (A) -> B) -> Result<B, Error> {
    a.map(f)
}

// MARK: -
