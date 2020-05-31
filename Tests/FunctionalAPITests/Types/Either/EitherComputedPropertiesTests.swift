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
}

extension String: Error {}

fileprivate let left = Either<String,Int>.left("I'm left")
fileprivate let right = Either<String,Int>.right(42)

fileprivate let leftNever = Either<Never,Int>.right(42)
fileprivate let leftError = Either<Error,Int>.left("I'm left")

fileprivate let rightNever = Either<String,Never>.left("I'm left")

fileprivate let rightNeverLeftError = Either<Error,Never>.left("I'm left")


