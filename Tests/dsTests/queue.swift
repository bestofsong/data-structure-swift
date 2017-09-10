import XCTest
@testable import ds

class QueueTests: XCTestCase {
  var q:ringqueue<Int> = ringqueue<Int>(0)
  
  override func setUp() {
    q = ringqueue<Int>(0)
  }
  
  func testIsEmpty() throws {
    XCTAssertTrue(q.isEmpty())
    try q.enqueue(1)
    XCTAssertTrue(!q.isEmpty())
  }

  func testEnqueueDequeue() throws {
    let v = 1;
    try q.enqueue(1)
    let vv = try q.dequeue()
    XCTAssertEqual(v, vv)
  }

  func testIsFull() throws {
    XCTAssertTrue(!q.isFull())

    let volume = type(of:q).CAP() - 1
    for ii in 1...volume {
      try q.enqueue(ii)
    }
    XCTAssertTrue(q.isFull())
  }

  func testWrapAroundEnqueue() throws {
    let volume = type(of:q).CAP() - 1
    for ii in 1...volume {
      try q.enqueue(ii)
    }

    XCTAssertEqual(1, try q.dequeue())
    try q.enqueue(volume + 1)
    for ii in 2...volume + 1 {
      XCTAssertEqual(ii, try q.dequeue())
    }
    XCTAssertTrue(q.isEmpty())
  }
  
  func testWrapAroundDequeue() throws {
    let volume = type(of:q).CAP() - 1
    
    for ii in 1...volume {
      try q.enqueue(ii)
    }
    
    
    XCTAssertTrue(q.isFull())
    
    for ii in 1...volume {
      XCTAssertEqual(ii, try q.dequeue())
    }
    
    for ii in 1...volume {
      try q.enqueue(ii)
    }
    
    XCTAssertTrue(q.isFull())
    
    XCTAssertEqual(1, try q.dequeue())

    for ii in 2...volume {
      XCTAssertEqual(ii, try q.dequeue())
    }

    XCTAssertTrue(q.isEmpty())
  }

  static var allTests = [
    ("testIsEmpty", testIsEmpty),
    ("testEnqueueDequeue", testEnqueueDequeue),
    ("testIsFull", testIsFull),
    ("testWrapAroundEnqueue", testWrapAroundEnqueue),
    ("testWrapAroundDequeue", testWrapAroundDequeue),
    ]
}
