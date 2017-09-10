protocol QueueType {
  associatedtype Item
  func enqueue(_ item: Item) throws -> Void
  func dequeue() throws -> Item
  func isEmpty() -> Bool
}

protocol RingQueueType: QueueType {
  func isFull() -> Bool
}

enum CollectionError: Error {
  case noRoom
  case noItem
}

public class ringqueue<Item>: RingQueueType {
  public init(_ initialValue: Item) {
    begin = 0
    end = 0
    cap = type(of: self).CAP()
    items = Array(repeating: initialValue, count: cap)
  }

  public func enqueue(_ item: Item) throws -> Void {
    if isFull() {
      throw CollectionError.noRoom
    }
    items[end] = item
    end = advance(end)
  }

  public func dequeue() throws -> Item {
    if isEmpty() {
      throw CollectionError.noItem
    }
    let ret = items[begin]
    begin = advance(begin)
    return ret
  }

  public func isEmpty() -> Bool {
    return begin == end
  }

  public func isFull() -> Bool {
    return begin == advance(end)
  }

  private func advance(_ idx: Int) -> Int {
    return (idx + 1) % cap;
  }

  static func CAP () -> Int {
    return 10
  }
  private var items: [Item]
  private var begin: Int
  private var end: Int
  private var cap: Int
}
