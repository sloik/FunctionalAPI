import XCTest
@testable import FunctionalAPI

final class MapTests: XCTestCase {
    func test_mapShouldApplyFunctionToValue() {
        // Arrange
        let value = 42
        
        // Act
        let result = map(value, increment)
        
        // Assert
        XCTAssertEqual(result, 43)
    }
    
    func test_mapShould_ApplyFunctionToSomeOptionalValue() {
        // Arrange
        let value: Int? = 42
        
        // Act
        let result = map(value, increment)
        
        // Assert
        XCTAssertNotNil(result)
        XCTAssertEqual(result, 43)
    }
    
    func test_mapShouldNot_ApplyFunctionToNoneOptionalValue() {
        // Arrange
        let value: Int? = nil
        
        // Act
        let result = map(value, increment)
        
        // Assert
        XCTAssertNil(result)
    }
    
    func test_mapShould_ApplyFunctionToArray() {
        // Arrange
        let value: [Int] = [10,20,30]
        
        // Act
        let result = map(value, increment)
        
        // Assert
        XCTAssertEqual(result, [11, 21, 31])
    }
}
