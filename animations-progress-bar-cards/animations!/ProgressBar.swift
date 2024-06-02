
import SwiftUI

struct ProgressBar: View {
    @Binding var percentage: CGFloat
    var width: CGFloat = 100
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3.0, style: .circular)
                .frame(width: width, height: 6)
                    .foregroundColor(Color.gray.opacity(0.2))

                RoundedRectangle(cornerRadius: 3.0, style: .circular)
                    .foregroundColor(Color.clear)
                    .background(
                      Color.blue
                        .cornerRadius(3)
                    )
                    .frame(width: (geo.size.width * percentage) > width ? width : (geo.size.width * percentage), height: 6)
            }
            .padding()
            .frame(height: 6)
        }
        .padding()
    }
}


#Preview {
  struct ProgressBarPR: View {
    
    @State private var progress: CGFloat = 0.6
    var body: some View {
      ProgressBar(percentage: $progress)
    }
  }
 return  ProgressBarPR()
}
