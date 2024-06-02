
import SwiftUI

struct Cards: View {

  @Namespace private var animation
  @State private var selectedCardIdx: Int = 0
  @State private var tapCount = 0
  @State private var isShowingSelectedView = false
  @State private var shouldExpandCards = false
  @State private var baseOffsets: [CGFloat] = [0, 5, 10, 15, 20, 25]
  private var offsets: [CGFloat] = [0, 5, 10, 15, 20, 25]

  var body: some View {
    if isShowingSelectedView {
      CardView(cardNum: selectedCardIdx)
        .onTapGesture {
          withAnimation(.easeOut)  {
            isShowingSelectedView.toggle()
            baseOffsets = offsets
            shouldExpandCards = false
          }
        }
    } else {
      ScrollView {
        ZStack {
          ForEach(0..<6, id: \.self) { idx in
            CardView(cardNum: idx)
              .offset(y: baseOffsets[idx])
              .onTapGesture {
                withAnimation(.snappy) {
                  tapCount += 1
                  if tapCount == 1 {
                    shouldExpandCards.toggle()
                    baseOffsets = shouldExpandCards ? baseOffsets.map { $0 * 10 } : offsets
                  }
                  if tapCount == 2 {
                    selectedCardIdx = idx
                    isShowingSelectedView = true
                    tapCount = 0
                  }
                }
              }
              .listRowSeparator(.hidden)
              .frame(height: 50)
          }
          .padding(.top, 100)

        }
      }
      .scrollContentBackground(.hidden)
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
  }

  struct CardView: View {
    var cardNum: Int
    var body: some View {
      RoundedRectangle(cornerRadius: 25.0)
        .frame(width: 300, height: 200)
        .foregroundStyle(.blue)
        .shadow(radius: 10)
        .overlay {
          Text("Card: \(cardNum)")
            .foregroundStyle(.white)
            .font(.title2)
        }
    }
  }
}

#Preview {
  Cards()
}
