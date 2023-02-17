import XCTest

import FunctionalAPI
import EitherSwift

class FunctorLawTests: XCTestCase {

    func test_Array() {
        let array = [1, 2, 3]

        // Identity Law: fmap id == id
        XCTAssertEqual(
            array.fmap { $0 } as! [Int],
            array
        )

        // Composition Law: fmap (f . g) == fmap f . fmap g
        let fmapGfmapF: [Int] = (array.fmap(f) as! [Int]).fmap(g) as! [Int]
        let fmapCompose: [Int] = array.fmap( compose(f, g) ) as! [Int]

        XCTAssertEqual(fmapGfmapF, fmapCompose)
    }

    func test_Either() {
        let sut = Either<Int,Int>.right(42)

        // Identity Law: fmap id == id
        XCTAssertEqual(
            sut.fmap { $0 } as! Either<Int,Int>,
            sut
        )

        // Composition Law: fmap (f . g) == fmap f . fmap g
        let fmapGfmapF: Either<Int,Int> = (sut.fmap(f) as! Either<Int,Int>).fmap(g) as! Either<Int,Int>
        let fmapCompose: Either<Int,Int> = sut.fmap( compose(f, g) ) as! Either<Int,Int>

        XCTAssertEqual(fmapGfmapF, fmapCompose)
    }

}

fileprivate let f = { $0 + 1 }
fileprivate let g = { $0 * 10 }
