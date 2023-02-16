import XCTest

import FunctionalAPI

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

}

fileprivate let f = { $0 + 1 }
fileprivate let g = { $0 * 10 }
