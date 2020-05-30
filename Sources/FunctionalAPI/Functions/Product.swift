
import Foundation

public func product<A,B>(_ aa: [A], _ bb: [B]) -> [(A,B)] {
    aa.flatMap { a in
        bb.map { b in
            (a, b)
        }
    }
}

public func product<A,B,C>(_ aa: [A], _ bb: [B], _ cc: [C]) -> [(A,B,C)] {
    product(aa, bb)
        .flatMap ({ (a, b) in
            cc.map{ c in (a, b, c) }
        })
}

public func product<A,B,C,D>(
    _ aa: [A],
    _ bb: [B],
    _ cc: [C],
    _ dd: [D]) -> [(A,B,C,D)] {
    product(aa, bb, cc)
        .flatMap({ (a, b, c) in
            dd.map{ d in (a, b, c, d) }
        })
}

public func product<A,B,C,D,E>(
    _ aa: [A],
    _ bb: [B],
    _ cc: [C],
    _ dd: [D],
    _ ee: [E]) -> [(A,B,C,D,E)] {
    product(aa, bb, cc,dd)
        .flatMap({ (a, b, c, d) in
            ee.map{ e in (a, b, c, d, e) }
        })
}


