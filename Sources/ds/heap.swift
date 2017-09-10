

public class heap <Element: Comparable> {

  public convenience init(elements: [Element]) {
    self.init(elements: elements, bigHead: true)
  }

  public convenience init(elements: [Element], bigHead: Bool) {
    self.init(elements: elements, bigHead: bigHead, growDelta: 64)
  }

  public init(elements: [Element], bigHead: Bool, growDelta: Int) {
    self.elements = []
    self.elements.append(contentsOf:elements)
    self.bigHead = bigHead
    self.growDelta = growDelta
    self.build()
  }

  public func isEmpty() -> Bool {
    return size == 0
  }

  public func extract() -> Element {
    assert(!isEmpty())
    let ret = elements[0]
    let last = elements.popLast()!
    if !isEmpty() {
      elements[0] = last
      adjustHead(0)
    }
    return ret
  }

  public func add(_ ele: Element) {
    if size >= elements.capacity {
      self.grow(growDelta)
    }
    elements.append(ele)

    var it = size - 1
    while it > 0 {
      let parent = (it - 1) >> 1
      if !compareElement(elements[parent], elements[it]) {
        elements.swapAt(parent, it)
      }
      it = parent
    }
  }

  public var size: Int {
    return elements.count
  }

  subscript(iii: Int) -> Element {
    return elements[iii]
  }

  private var elements: [Element]
  private var bigHead: Bool
  private let growDelta: Int

  private func grow(_ more: Int) {
    assert(more > 0)
    elements.reserveCapacity(elements.capacity + more)
  }

  // check if lhs has more priority than rhs
  private func compareElement(_ lhs: Element, _ rhs: Element) -> Bool {
    if bigHead {
      return rhs < lhs
    } else {
      return lhs < rhs
    }
  }

  private func build() {
    let lastParent = (size - 1) >> 1
    if lastParent < 0 {
      return
    }
    for i in (0...lastParent).reversed() {
      self.adjustHead(i)
    }
  }

  private func adjustHead(_ parent: Int) {
    let ll = (parent << 1) + 1
    let rr = ll + 1

    if ll >= size {
      return
    }

    if compareElement(elements[parent], elements[ll]) &&
    (rr >= size || compareElement(elements[parent], elements[rr])) {
      return
    }

    if rr >= size || compareElement(elements[ll], elements[rr]) {
      elements.swapAt(parent, ll)
      adjustHead(ll)
    } else {
      elements.swapAt(parent, rr)
      adjustHead(rr)
    }
  }
}
