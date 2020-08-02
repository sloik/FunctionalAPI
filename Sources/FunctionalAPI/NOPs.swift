
import Foundation

/// Function that does nothing.
public func nop() -> Void {}

/// Function that ignores it inputs and does nothing.
public func nop<A>(_: A) -> Void { }

/// Function that ignores it inputs and does nothing.
public func nop<A,B>(_: A, _: B) -> Void { }

/// Function that ignores it inputs and does nothing.
public func nop<A,B,C>(_: A, _: B, _: C) -> Void { }

/// Function that ignores it inputs and does nothing.
public func nop<A,B,C,D>(_: A, _: B, _: C, _: D) -> Void { }
