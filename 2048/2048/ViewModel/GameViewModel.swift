
import Foundation
import Combine
import SwiftUI

class GameViewModel: ObservableObject {

  enum Direction {

      case left
      case right
      case up
      case down

  }

  @Published fileprivate(set) var lastGestureDirection: Direction = .up

  typealias BoardMatrixType = GameMatrix<IdentifiedBoard>

  let objectWillChange = PassthroughSubject<GameViewModel, Never>()

  fileprivate var _boardMatrix: BoardMatrixType!
  var boardMatrix: BoardMatrixType {
      return _boardMatrix
  }

  fileprivate var _globalID = 0
  fileprivate var newGlobalID: Int {
      _globalID += 1
      return _globalID
  }

  init() {
      newGame()
  }

  func newGame() {
      _boardMatrix = BoardMatrixType()
      resetLastGestureDirection()
      generateNewBlocks()

      objectWillChange.send(self)
  }

  func resetLastGestureDirection() {
      lastGestureDirection = .up
  }

  @discardableResult fileprivate func generateNewBlocks() -> Bool {
    var blankLocations = [BoardMatrixType.Index]()
    for rowIndex in 0..<4 {
      for colIndex in 0..<4 {
        let index = (colIndex, rowIndex)
        if _boardMatrix[index] == nil {
          blankLocations.append(index)
        }
      }
    }

    guard blankLocations.count >= 2 else {
      return false
    }

    // Don't forget to sync data.
    defer {
      objectWillChange.send(self)
    }

    // Place the first block.
    var placeLocIndex = Int.random(in: 0..<blankLocations.count)
    _boardMatrix.place(IdentifiedBoard(
      id: newGlobalID,
      number: 2
    ), to: blankLocations[placeLocIndex]
    )

    // Place the second block.
    guard let lastLoc = blankLocations.last else {
      return false
    }
    blankLocations[placeLocIndex] = lastLoc
    placeLocIndex = Int.random(in: 0..<(blankLocations.count - 1))
    _boardMatrix.place(IdentifiedBoard(id: newGlobalID, number: 2), to: blankLocations[placeLocIndex])

    return true
  }

  func move(_ direction: Direction) {
    defer {
        objectWillChange.send(self)
    }

    lastGestureDirection = direction

    var moved = false

    let axis = direction == .left || direction == .right
    for row in 0..<4 {
        var rowSnapshot = [IdentifiedBoard?]()
        var compactRow = [IdentifiedBoard]()
        for col in 0..<4 {
            // Transpose if necessary.
            if let block = _boardMatrix[axis ? (col, row) : (row, col)] {
                rowSnapshot.append(block)
                compactRow.append(block)
            }
            rowSnapshot.append(nil)
        }

        merge(blocks: &compactRow, reverse: direction == .down || direction == .right)

        var newRow = [IdentifiedBoard?]()
        compactRow.forEach { newRow.append($0) }
        if compactRow.count < 4 {
            for _ in 0..<(4 - compactRow.count) {
                if direction == .left || direction == .up {
                    newRow.append(nil)
                } else {
                    newRow.insert(nil, at: 0)
                }
            }
        }

        newRow.enumerated().forEach {
            if rowSnapshot[$0]?.number != $1?.number {
                moved = true
            }
            _boardMatrix.place($1, to: axis ? ($0, row) : (row, $0))
        }
    }

    if moved {
        generateNewBlocks()
    }
  }

  fileprivate func merge(blocks: inout [IdentifiedBoard], reverse: Bool) {
    if reverse {
      blocks = blocks.reversed()
    }

    blocks = blocks
      .map { (false, $0) }
      .reduce([(Bool, IdentifiedBoard)]()) { acc, item in
        if acc.last?.0 == false && acc.last?.1.number == item.1.number {
          var accPrefix = Array(acc.dropLast())
          var mergedBlock = item.1
          mergedBlock.number *= 2
          accPrefix.append((true, mergedBlock))
          return accPrefix
        } else {
          var accTmp = acc
          accTmp.append((false, item.1))
          return accTmp
        }
      }
      .map { $0.1 }

    if reverse {
      blocks = blocks.reversed()
    }
  }

}
