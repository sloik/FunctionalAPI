import XCTest

import FunctionalAPITests

var tests = [XCTestCaseEntry]()
tests += FunctionalAPITests.allTests()
XCTMain(tests)
