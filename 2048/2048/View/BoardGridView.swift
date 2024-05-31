
import SwiftUI

struct BoardGridView : View {
typealias SupportingMatrix = GameMatrix<IdentifiedBoard>

let matrix: Self.SupportingMatrix
let blockEnterEdge: Edge

  func createBlock(
    _ board: IdentifiedBoard?,
    at index: IndexedBlock<IdentifiedBoard>.Index
  ) -> some View {
    let boardView: BoardView
    if let board = board {
        boardView = BoardView(block: board)
    } else {
        boardView = BoardView.blank
    }

    let blockSize: CGFloat = 65
    let spacing: CGFloat = 12

    let position = CGPoint(
        x: CGFloat(index.0) * (blockSize + spacing) + blockSize / 2 + spacing,
        y: CGFloat(index.1) * (blockSize + spacing) + blockSize / 2 + spacing
    )

    return boardView
        .frame(width: 65, height: 65, alignment: .center)
        .position(x: position.x, y: position.y)
        .transition(.blockGenerated(
            from: self.blockEnterEdge,
            position: CGPoint(x: position.x, y: position.y),
            in: CGRect(x: 0, y: 0, width: 320, height: 320)
        ))
}


var body: some View {
    ZStack {
        // Background grid blocks:
        ForEach(0..<4) { x in
            ForEach(0..<4) { y in
                self.createBlock(nil, at: (x, y))
            }
        }
        .zIndex(1)

        // Number blocks:
        ForEach(self.matrix.flatten, id: \.item.id) {
            self.createBlock($0.item, at: $0.index)
        }
        .zIndex(1000)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9))
    }
    .frame(width: 320, height: 320, alignment: .center)
    .background(
        Rectangle()
            .fill(Color(red:0.72, green:0.66, blue:0.63, opacity:1.00))
    )
    .clipped()
    .cornerRadius(6)
    .drawingGroup(opaque: false, colorMode: .linear)
}

}

struct BoardGridView_Previews : PreviewProvider {

static var matrix: BoardGridView.SupportingMatrix {
    var _matrix = BoardGridView.SupportingMatrix()
    _matrix.place(IdentifiedBoard(id: 1, number: 2), to: (2, 0))
    _matrix.place(IdentifiedBoard(id: 2, number: 2), to: (3, 0))
    _matrix.place(IdentifiedBoard(id: 3, number: 8), to: (1, 1))
    _matrix.place(IdentifiedBoard(id: 4, number: 4), to: (2, 1))
    _matrix.place(IdentifiedBoard(id: 5, number: 512), to: (3, 3))
    _matrix.place(IdentifiedBoard(id: 6, number: 1024), to: (2, 3))
    _matrix.place(IdentifiedBoard(id: 7, number: 16), to: (0, 3))
    _matrix.place(IdentifiedBoard(id: 8, number: 8), to: (1, 3))
    return _matrix
}

static var previews: some View {
  BoardGridView(matrix: matrix, blockEnterEdge: .top)
        .previewLayout(.sizeThatFits)
}

}
