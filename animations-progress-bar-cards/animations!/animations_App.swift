
import SwiftUI

@main
struct animations_App: App {
    var body: some Scene {
        WindowGroup {
          // ProgressContent()
          Cards()
        }
    }
}


import SwiftUI

struct ProgressContent: View {
    @State private var percentage: CGFloat = 0.0
    private let timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            ProgressBar(percentage: $percentage, width: 200)
                .onReceive(timer) { _ in
                    withAnimation(.easeInOut(duration: 2.0)) {
                      self.percentage = self.percentage < 1.0 ? self.percentage + 0.1 : 0.0
                    }
                }
        }

    }
}

