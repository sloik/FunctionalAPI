
import Foundation

public func product<A,B>(_ aa: [A], _ bb: [B]) -> [(A,B)] {
    aa.flatMap { a in
        bb.map { b in
            (a, b)
        }
    }
}

public func product<A,B,C>(_ aa: [A], _ bb: [B], _ cc: [C]) -> [(A,B,C)] {
    aa.flatMap { a in
        bb.flatMap { b in
            cc.map { c in
                (a, b, c)
            }
        }
    }
}

public func product<A,B,C,D>(
    _ aa: [A],
    _ bb: [B],
    _ cc: [C],
    _ dd: [D]) -> [(A,B,C,D)] {
    aa.flatMap { a in
        bb.flatMap { b in
            cc.flatMap { c in
                dd.map { d in
                    (a, b, c, d)
                }
            }
        }
    }
}




