
import Foundation

#if DEBUG

public func developmentValue<A>(_ tempValue: A) -> A { tempValue }

public func temporayValue<T>(
    _ message: @autoclosure () -> String = String(),
    file: StaticString = #file,
    line: UInt = #line
) -> T {
    fatalError(message(), file: file, line: line)
}

#endif
