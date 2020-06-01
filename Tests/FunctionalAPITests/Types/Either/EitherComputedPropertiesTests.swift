import XCTest
@testable import FunctionalAPI
import OptionalAPI
import SnapshotTesting

class EitherComputedPropertiesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        record = false
    }

// MARK: - Computed Properties
    func test_isLeft() {
        XCTAssertTrue(left.isLeft)
        XCTAssertFalse(right.isLeft)
    }
    
    func test_isRight() {
        XCTAssertFalse(left.isRight)
        XCTAssertTrue(right.isRight)
    }
    
    func test_right() {
        XCTAssertNotNil(right.right)
        XCTAssertEqual(right.right, 42)
    }
    
    func test_left() {
        XCTAssertNotNil(left.left)
        XCTAssertEqual(left.left, "I'm left")
    }
    
    func test_toOptional() {
        XCTAssertNotNil(
            right.toOptional,
            "should be the same as .some case in Optional"
        )
        
        XCTAssertNil(
            left.toOptional,
            "should be the same as the .none case in Optional"
        )
    }
    
    func test_toResult() {
        let rightResult: Result<Int?, Never> = right.toResult
        let  leftResult: Result<Int?, Never> = left.toResult
        
        switch rightResult {
        case .success(let value):
            XCTAssertNotNil(value)
            XCTAssertEqual(value, 42)
        }
        
        switch leftResult {
        case .success(let value):
            XCTAssertNil(value)
        }
    }
    
    func test_whenLeft_isNever() {
        let _: Int = leftNever.right
        let _: Result<Int, Never> = leftNever.toResult
    }
    
    func test_whenLeft_isError() {
        let _: Result<Int,Error> = leftError.toResult
    }
    
    func test_whenLeftError_and_rightNever() {
        let _: Error = rightNeverLeftError.left
        let _: Result<Never, Error> = rightNeverLeftError.toResult
    }
    
    // MARK: - Equatable
    
    func test_eq() {
        XCTAssertTrue(left == left)
        XCTAssertTrue(right == right)
        XCTAssertFalse(left == right)
        XCTAssertFalse(right == left)
    }
    
    // MARK: - Maps
    func test_map() {
        XCTAssertEqual(right.map(identity), right)
        XCTAssertTrue (right.map(increment).isRight)
        XCTAssertEqual(right.map(increment).right, 43)
        
        XCTAssertEqual(left.map(identity), left)
        XCTAssertTrue (left.map(increment).isLeft)
        XCTAssertEqual(left.map(increment).left, "I'm left")
    }
    
    func test_free_map() {
        XCTAssertEqual(map(right, identity), right)
        XCTAssertTrue (map(right, increment).isRight)
        XCTAssertEqual(map(right, increment).right, 43)
        
        XCTAssertEqual(map(left, identity), left)
        XCTAssertTrue (map(left, increment).isLeft)
        XCTAssertEqual(map(left, increment).left, "I'm left")
    }
    
    func test_mapRight() {
        XCTAssertEqual(right.mapRight(identity), right)
        XCTAssertTrue (right.mapRight(increment).isRight)
        XCTAssertEqual(right.mapRight(increment).right, 43)
        
        XCTAssertEqual(left.mapRight(identity), left)
        XCTAssertTrue (left.mapRight(increment).isLeft)
        XCTAssertEqual(left.mapRight(increment).left, "I'm left")
    }
    
    func test_free_mapRight() {
        XCTAssertEqual(mapRight(right, identity), right)
        XCTAssertTrue (mapRight(right, increment).isRight)
        XCTAssertEqual(mapRight(right, increment).right, 43)
        
        XCTAssertEqual(mapRight(left, identity), left)
        XCTAssertTrue (mapRight(left, increment).isLeft)
        XCTAssertEqual(mapRight(left, increment).left, "I'm left")
    }
    
    func test_mapLeft() {
        XCTAssertEqual(right.mapLeft(identity), right)
        XCTAssertTrue (right.mapLeft({ $0.uppercased() }).isRight)
        XCTAssertEqual(right.mapLeft({ $0.uppercased() }).right, 42)
        
        XCTAssertEqual(left.mapLeft(identity), left)
        XCTAssertTrue (left.mapLeft({ $0.uppercased() }).isLeft)
        XCTAssertEqual(left.mapLeft({ $0.uppercased() }).left, "I'M LEFT")
    }
    
    func test_free_mapLeft() {
        XCTAssertEqual(mapLeft(right, identity), right)
        XCTAssertTrue (mapLeft(right, { $0.uppercased() }).isRight)
        XCTAssertEqual(mapLeft(right, { $0.uppercased() }).right, 42)
        
        XCTAssertEqual(mapLeft(left, identity), left)
        XCTAssertTrue (mapLeft(left, { $0.uppercased() }).isLeft)
        XCTAssertEqual(mapLeft(left, { $0.uppercased() }).left, "I'M LEFT")
    }
    
    func test_mapBi() {
        XCTAssertEqual(right.mapBi(identity, identity), right)
        XCTAssertEqual(left.mapBi(identity, identity), left)
        
        XCTAssertEqual(
            right.mapBi({ $0.uppercased() }, increment),
            .right(43)
        )
        
        XCTAssertEqual(
            left.mapBi({ $0.uppercased() }, increment),
            .left("I'M LEFT")
        )
    }
    
    func test_free_mapBi() {
        XCTAssertEqual(mapBi(right, identity, identity), right)
        XCTAssertEqual(mapBi(left, identity, identity), left)
        
        XCTAssertEqual(
            mapBi(right, { $0.uppercased() }, increment),
            .right(43)
        )
        
        XCTAssertEqual(
            mapBi(left, { $0.uppercased() }, increment),
            .left("I'M LEFT")
        )
    }
    
    // MARK: Flat Maps
    
    func test_flatMap() {
        let rightResult: Either<String, Character> = right.flatMap(alwaysRight)
        XCTAssertTrue(rightResult.isRight)
        XCTAssertEqual(rightResult.right!, "C", "Should transform original value!")
        
        
        let leftResult: Either<String, Character> = left.flatMap(alwaysLeft)
        XCTAssertTrue(leftResult.isLeft)
        XCTAssertEqual(leftResult.left, left.left, "Should not change left value!")
    }
    
    func test_free_flatMap() {
        let rightResult: Either<String, Character> = flatMap(right, alwaysRight)
        XCTAssertTrue(rightResult.isRight)
        XCTAssertEqual(rightResult.right!, "C", "Should transform original value!")
        
        
        let leftResult: Either<String, Character> = flatMap(left, alwaysLeft)
        XCTAssertTrue(leftResult.isLeft)
        XCTAssertEqual(leftResult.left, left.left, "Should not change the left value!")
    }
    
    func test_flatMapRight() {
        let rightResult: Either<String, Character> = right.flatMapRight(alwaysRight)
        XCTAssertTrue(rightResult.isRight)
        XCTAssertEqual(rightResult.right!, "C")
        
        
        let leftResult: Either<String, Character> = left.flatMapRight(alwaysLeft)
        XCTAssertTrue(leftResult.isLeft)
        XCTAssertEqual(leftResult.left, left.left, "Should not change the left value!")
    }
    
    func test_free_flatMapRight() {
        let rightResult: Either<String, Character> = flatMapRight(right, alwaysRight)
        XCTAssertTrue(rightResult.isRight)
        XCTAssertEqual(rightResult.right!, "C", "Should transform original value!")
        
        
        let leftResult: Either<String, Character> = flatMapRight(left, alwaysLeft)
        XCTAssertTrue(leftResult.isLeft)
        XCTAssertEqual(leftResult.left, left.left, "Should not change the left value!")
    }
    
    func test_flatMapLeft() {
        let rightResult: Either<Character, Int> = right.flatMapLeft(alwaysRight)
        XCTAssertTrue(rightResult.isRight)
        XCTAssertEqual(rightResult.right, right.right, "Should not mutate right value!")
        
        
        let leftResult: Either<Character, Int> = left.flatMapLeft(alwaysLeft)
        XCTAssertTrue(leftResult.isLeft)
        XCTAssertEqual(leftResult.left, "C", "Should change left value!")
    }
    
    func test_free_flatMapLeft() {
        let rightResult: Either<Character, Int> = flatMapLeft(right, alwaysRight)
        XCTAssertTrue(rightResult.isRight)
        XCTAssertEqual(rightResult.right, right.right, "Should not mutate right value!")
        
        
        let leftResult: Either<Character, Int> = flatMapLeft(left, alwaysLeft)
        XCTAssertTrue(leftResult.isLeft)
        XCTAssertEqual(leftResult.left, "C", "Should change left value!")
    }
    
    // MARK: - Utils
    func test_lefts() {
        XCTAssertEqual(
            lefts(eithers),
            ["A", "B"]
        )
        
        XCTAssertEqual(
            lefts(eithersEmpty),
            []
        )
    }
    
    func test_rights() {
        XCTAssertEqual(
            rights(eithers),
            [42, 24]
        )
        
        XCTAssertEqual(
            rights(eithersEmpty),
            []
        )
    }
    
    func test_partitionEithers() {
        let (lefts, rights) = partitionEithers(eithers)
        XCTAssertEqual(
            lefts,
            ["A", "B"]
        )
        
        XCTAssertEqual(
            rights,
            [42, 24]
        )
        
        let (emptyLefts, emptyRights) = partitionEithers(eithersEmpty)
        XCTAssertEqual(
            emptyLefts,
            []
        )
        
        XCTAssertEqual(
            emptyRights,
            []
        )
    }
    
    func test_either() {
        // Arrange
        let leftTransform: (String) -> [Int] = { [$0.count] }
        let rightTransform: (Int) -> [Int] = { [$0] }
        
        let ey = either(leftTransform, rightTransform)
        
        // Act
        let fromLeft = ey(left)
        let fromRight = ey(right)
        
        // Act
        XCTAssertEqual(
            fromLeft,
            [8],
            "Should produce an array with the length of the string!"
        )
        
        XCTAssertEqual(
            fromRight,
            [42],
            "Should produce an array with the value wrapped in an array!"
        )
    }
    
    func test_fromLeft() {
        XCTAssertEqual(
            left.fromLeft("Default Left"),
            "I'm left",
            "Should return value stored in left!"
        )
        
        XCTAssertEqual(
            right.fromLeft("Default Left"),
            "Default Left",
            "Should return default value when run on right!"
        )
    }
    
    func test_fromRight() {
        XCTAssertEqual(
            right.fromRight(69),
            42,
            "Should return value stored in left!"
        )
        
        XCTAssertEqual(
            left.fromRight(69),
            69,
            "Should return default value when run on right!"
        )
    }
}

extension String: Error {}

fileprivate let eithers: [Either<String,Int>] = [ .left("A"), .right(42), .left("B"), .right(24) ]
fileprivate let eithersEmpty: [Either<String,Int>] = []


fileprivate let left = Either<String,Int>.left("I'm left")
fileprivate let right = Either<String,Int>.right(42)

fileprivate let leftNever = Either<Never,Int>.right(42)
fileprivate let leftError = Either<Error,Int>.left("I'm left")

fileprivate let rightNever = Either<String,Never>.left("I'm left")

fileprivate let rightNeverLeftError = Either<Error,Never>.left("I'm left")

fileprivate func alwaysRight(_ i: Int) -> Either<String, Character> {
    .right("C")
}

fileprivate func alwaysLeft(_ i: Int) -> Either<String, Character> {
    .left("C")
}

fileprivate func alwaysRight(_ s: String) -> Either<Character, Int> {
    .right(69)
}

fileprivate func alwaysLeft(_ s: String) -> Either<Character, Int> {
    .left("C")
}
