import XCTest
@testable import ds

class DataStructureTests: XCTestCase {
    func validateHeap<Element>(_ heap: heap<Element>, _ bigHead: Bool ) {
        for pp in 0...heap.size {
            let ll = 2 * pp + 1
            let rr = ll + 1
            let children = [ll, rr]
            for jj in children where jj < heap.size {
                if bigHead {
                    XCTAssert(heap[pp] > heap[jj])
                } else {
                    XCTAssert(heap[pp] < heap[jj])
                }
            }
        }
    }

    let initialArray = [1, 2, 3, 4, 5, 6]

    func testHeapInit() {
        let h = heap(elements: initialArray, bigHead:true)
        validateHeap(h, true)
        XCTAssertEqual(h.size, initialArray.count)
    }

    func testHeapInitSmallHead() {
        let h = heap(elements: initialArray, bigHead:false)
        validateHeap(h, false)
        XCTAssertEqual(h.size, initialArray.count)
    }

    func testHeapAdd() {
        let h = heap(elements: initialArray, bigHead:true)
        h.add(7)
        validateHeap(h, true)
        XCTAssertEqual(h.size, initialArray.count + 1)
    }

    func testHeapExtract() {
        let h = heap(elements: initialArray, bigHead:true)
        let _ = h.extract()
        validateHeap(h, true)
        XCTAssertEqual(h.size, initialArray.count - 1)
    }

    static var allTests = [
        ("heapInit", testHeapInit),
        ("heapAdd", testHeapAdd),
        ("heapExtract", testHeapExtract),
        ("testHeapInitSmallHead", testHeapInitSmallHead),
    ]
}
