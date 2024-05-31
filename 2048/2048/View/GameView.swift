

import SwiftUI

struct GameView : View {

    @State var ignoreGesture = false
    @ObservedObject var viewModel: GameViewModel
    var gestureEnabled = true

    fileprivate struct LayoutTraits {
        let bannerOffset: CGSize
        let showsBanner: Bool
        let containerAlignment: Alignment
    }

    fileprivate func layoutTraits(`for` proxy: GeometryProxy) -> LayoutTraits {
        let landscape = proxy.size.width > proxy.size.height
        return LayoutTraits(
            bannerOffset: landscape
                ? .init(width: 32, height: 0)
                : .init(width: 0, height: 32),
            showsBanner: landscape ? proxy.size.width > 720 : proxy.size.height > 550,
            containerAlignment: landscape ? .leading : .top
        )
    }

    var gesture: some Gesture {
        let threshold: CGFloat = 44
        let drag = DragGesture()
            .onChanged { v in
                guard !self.ignoreGesture else { return }

                guard abs(v.translation.width) > threshold ||
                    abs(v.translation.height) > threshold else {
                    return
                }

              withTransaction(Transaction(animation: .easeIn)) {
                    self.ignoreGesture = true

                    if v.translation.width > threshold {
                        self.viewModel.move(.right)
                    } else if v.translation.width < -threshold {
                        self.viewModel.move(.left)
                    } else if v.translation.height > threshold {
                        self.viewModel.move(.down)
                    } else if v.translation.height < -threshold {
                        // Move up
                        self.viewModel.move(.up)
                    }
                }
            }
            .onEnded { _ in
                self.ignoreGesture = false
            }
        return drag
    }

    var content: some View {
        GeometryReader { proxy in
            bind(self.layoutTraits(for: proxy)) { layoutTraits in
                ZStack(alignment: layoutTraits.containerAlignment) {
                    if layoutTraits.showsBanner {
                        Text("2048")
                            .font(Font.system(size: 48).weight(.black))
                            .foregroundColor(Color(red:0.47, green:0.43, blue:0.40, opacity:1.00))
                            .offset(layoutTraits.bannerOffset)
                    }

                    ZStack(alignment: .center) {
                      BoardGridView(matrix: self.viewModel.boardMatrix,
                                    blockEnterEdge: .from(self.viewModel.lastGestureDirection))
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                }
                .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
                .background(
                    Rectangle()
                        .fill(Color(red:0.96, green:0.94, blue:0.90, opacity:1.00))
                        .edgesIgnoringSafeArea(.all)
                )
            }
        }
    }

    var body: some View {
            content
                .gesture(gesture, including: .all)
    }

}

func bind<T, U>(_ x: T, _ closure: (T) -> U) -> U {
    return closure(x)
}

