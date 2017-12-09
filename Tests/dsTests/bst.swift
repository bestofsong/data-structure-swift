import XCTest
@testable import ds

class BstTests: XCTestCase {
  let initialArray = [3, 1, 2, 5, 4, 6]

  func testRmLeft() {
    let bst = Bst(array: initialArray)
    let (afterTrim, lastRm) = bst.removeLeft(3)
    XCTAssertTrue(bst.isBst(minValue: Int.min, maxValue: Int.max))
    XCTAssertTrue(afterTrim!.isBst(minValue: Int.min, maxValue: Int.max))
    XCTAssertTrue(lastRm!.isBst(minValue: Int.min, maxValue: Int.max))
    XCTAssertFalse(afterTrim!.contains(value: 1))
    XCTAssertFalse(afterTrim!.contains(value: 2))
    XCTAssertFalse(afterTrim!.contains(value: 3))
    XCTAssertTrue(afterTrim!.contains(value: 4))
    XCTAssertTrue(afterTrim!.contains(value: 5))
    XCTAssertTrue(afterTrim!.contains(value: 6))
    XCTAssertEqual(lastRm!.maximum().value, 3)
  }

  static var allTests = [
    ("rmLeft", testRmLeft)
  ]
}
