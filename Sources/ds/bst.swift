/*
  A binary search tree.

  Each node stores a value and two children. The left child contains a smaller
  value; the right a larger (or equal) value.

  This tree allows duplicate elements.

  This tree does not automatically balance itself. To make sure it is balanced,
  you should insert new values in randomized order, not in sorted order.
*/
public class Bst<T: Comparable> {
  fileprivate(set) public var value: T
  fileprivate(set) public var parent: Bst?
  fileprivate(set) public var left: Bst?
  fileprivate(set) public var right: Bst?

  public init(value: T) {
    self.value = value
  }

  public convenience init(array: [T]) {
    precondition(array.count > 0)
    self.init(value: array.first!)
    for v in array.dropFirst() {
      insert(value: v)
    }
  }

  public var isRoot: Bool {
    return parent == nil
  }

  public var isLeaf: Bool {
    return left == nil && right == nil
  }

  public var isLeftChild: Bool {
    return parent?.left === self
  }

  public var isRightChild: Bool {
    return parent?.right === self
  }

  public var hasLeftChild: Bool {
    return left != nil
  }

  public var hasRightChild: Bool {
    return right != nil
  }

  public var hasAnyChild: Bool {
    return hasLeftChild || hasRightChild
  }

  public var hasBothChildren: Bool {
    return hasLeftChild && hasRightChild
  }

  /* How many nodes are in this subtree. Performance: O(n). */
  public var count: Int {
    return (left?.count ?? 0) + 1 + (right?.count ?? 0)
  }
}

// MARK: - Adding items

extension Bst {
  /*
    Inserts a new element into the tree. You should only insert elements
    at the root, to make to sure this remains a valid binary tree!
    Performance: runs in O(h) time, where h is the height of the tree.
  */
  public func insert(value: T) {
    if value < self.value {
      if let left = left {
        left.insert(value: value)
      } else {
        left = Bst(value: value)
        left?.parent = self
      }
    } else {
      if let right = right {
        right.insert(value: value)
      } else {
        right = Bst(value: value)
        right?.parent = self
      }
    }
  }
}

// MARK: - Deleting items

extension Bst {
  /*
    Deletes a node from the tree.

    Returns the node that has replaced this removed one (or nil if this was a
    leaf node). That is primarily useful for when you delete the root node, in
    which case the tree gets a new root.

    Performance: runs in O(h) time, where h is the height of the tree.
  */
  @discardableResult public func remove() -> Bst? {
    let replacement: Bst?

    // Replacement for current node can be either biggest one on the left or
    // smallest one on the right, whichever is not nil
    if let right = right {
      replacement = right.minimum()
    } else if let left = left {
      replacement = left.maximum()
    } else {
      replacement = nil
    }

    replacement?.remove()

    // Place the replacement on current node's position
    replacement?.right = right
    replacement?.left = left
    right?.parent = replacement
    left?.parent = replacement
    reconnectParentTo(node: replacement)

    // The current node is no longer part of the tree, so clean it up.
    parent = nil
    left = nil
    right = nil

    return replacement
  }

  private func reconnectParentTo(node: Bst?) {
    if let parent = parent {
      if isLeftChild {
        parent.left = node
      } else {
        parent.right = node
      }
    }
    node?.parent = parent
  }
}

// MARK: - Searching

extension Bst {
  /*
    Finds the "highest" node with the specified value.
    Performance: runs in O(h) time, where h is the height of the tree.
  */
  public func search(value: T) -> Bst? {
    var node: Bst? = self
    while let n = node {
      if value < n.value {
        node = n.left
      } else if value > n.value {
        node = n.right
      } else {
        return node
      }
    }
    return nil
  }

  /*
  // Recursive version of search
  public func search(value: T) -> Bst? {
    if value < self.value {
      return left?.search(value)
    } else if value > self.value {
      return right?.search(value)
    } else {
      return self  // found it!
    }
  }
  */

  public func contains(value: T) -> Bool {
    return search(value: value) != nil
  }

  /*
    Returns the leftmost descendent. O(h) time.
  */
  public func minimum() -> Bst {
    var node = self
    while let next = node.left {
      node = next
    }
    return node
  }

  /*
    Returns the rightmost descendent. O(h) time.
  */
  public func maximum() -> Bst {
    var node = self
    while let next = node.right {
      node = next
    }
    return node
  }

  /*
    Calculates the depth of this node, i.e. the distance to the root.
    Takes O(h) time.
  */
  public func depth() -> Int {
    var node = self
    var edges = 0
    while let parent = node.parent {
      node = parent
      edges += 1
    }
    return edges
  }

  /*
    Calculates the height of this node, i.e. the distance to the lowest leaf.
    Since this looks at all children of this node, performance is O(n).
  */
  public func height() -> Int {
    if isLeaf {
      return 0
    } else {
      return 1 + max(left?.height() ?? 0, right?.height() ?? 0)
    }
  }

  /*
    Finds the node whose value precedes our value in sorted order.
  */
  public func predecessor() -> Bst<T>? {
    if let left = left {
      return left.maximum()
    } else {
      var node = self
      while let parent = node.parent {
        if parent.value < value { return parent }
        node = parent
      }
      return nil
    }
  }

  /*
    Finds the node whose value succeeds our value in sorted order.
  */
  public func successor() -> Bst<T>? {
    if let right = right {
      return right.minimum()
    } else {
      var node = self
      while let parent = node.parent {
        if parent.value > value { return parent }
        node = parent
      }
      return nil
    }
  }
}

// MARK: - Traversal

extension Bst {
  public func traverseInOrder(process: (T) -> Void) {
    left?.traverseInOrder(process: process)
    process(value)
    right?.traverseInOrder(process: process)
  }

  public func traversePreOrder(process: (T) -> Void) {
    process(value)
    left?.traversePreOrder(process: process)
    right?.traversePreOrder(process: process)
  }

  public func traversePostOrder(process: (T) -> Void) {
    left?.traversePostOrder(process: process)
    right?.traversePostOrder(process: process)
    process(value)
  }

  /*
    Performs an in-order traversal and collects the results in an array.
  */
  public func map(formula: (T) -> T) -> [T] {
    var a = [T]()
    if let left = left { a += left.map(formula: formula) }
    a.append(formula(value))
    if let right = right { a += right.map(formula: formula) }
    return a
  }
}

/*
  Is this binary tree a valid binary search tree?
*/
extension Bst {
  public func isBst(minValue: T, maxValue: T) -> Bool {
    if value < minValue || value > maxValue { return false }
    let leftBst = left?.isBst(minValue: minValue, maxValue: value) ?? true
    let rightBst = right?.isBst(minValue: value, maxValue: maxValue) ?? true
    return leftBst && rightBst
  }
}

// MARK: - Debugging

extension Bst: CustomStringConvertible {
  public var description: String {
    var s = ""
    if let left = left {
      s += "(\(left.description)) <- "
    }
    s += "\(value)"
    if let right = right {
      s += " -> (\(right.description))"
    }
    return s
  }

   public func toArray() -> [T] {
      return map { $0 }
   }

}

//extension Bst: CustomDebugStringConvertible {
//  public var debugDescription: String {
//   var s = ""
//   if let left = left {
//      s += "(\(left.description)) <- "
//   }
//   s += "\(value)"
//   if let right = right {
//      s += " -> (\(right.description))"
//   }
//   return s
//  }
//}

extension Bst {
  public func removeRight(_ value: T) -> (Bst?, Bst?) {
    return remove(
      shouldRemove: { $0.value >= value },
      getNext: { $0.value >= value ? $0.left : $0.right })
  }

  public func removeLeft(_ value: T) -> (Bst?, Bst?) {
    return remove(
      shouldRemove: { $0.value <= value },
      getNext: { $0.value <= value ? $0.right : $0.left })
  }

  public func remove(
    shouldRemove: (_ node: Bst) -> Bool,
    getNext: (_ node: Bst) -> Bst?) -> (Bst?, Bst?) {

    var result_tree: Bst? = nil
    var last_remove: Bst? = nil
    let next = getNext(self)

    if shouldRemove(self) {
      last_remove = self
      if let res = next?.remove(shouldRemove: shouldRemove, getNext: getNext) {
        result_tree = res.0
        if res.1 != nil {
          last_remove = res.1
        }
      }

      next?.parent = nil
      if next != nil && left === next {
        left = nil
      } else if next != nil && right === next {
        right = nil
      }
    } else {
      result_tree = self
      if let res = next?.remove(shouldRemove: shouldRemove, getNext: getNext) {
        last_remove = res.1
      }
    }

    return (result_tree, last_remove)
  }
}
