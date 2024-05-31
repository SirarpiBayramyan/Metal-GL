
import SwiftUI

struct ThemeColorPaletteView: View {
     @Environment(\.dismiss) private var dismiss
     @Binding var themeColor: Color

    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                selectedColorHeader
                colorGrid
            }
            .navigationTitle("Set Theme Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                    }
                }
            }
        }
    }
    
    private var selectedColorHeader: some View {
        HStack(spacing: 20) {
            Text("Selected Theme Color:")
                .font(.title).bold()
            RoundedRectangle(cornerRadius: 10)
                .fill(themeColor)
                .frame(width: 50, height: 50)
        }
    }
    
    private var colorGrid: some View {
        Grid(horizontalSpacing: 30) {
            GridRow {
              ColorCircleView(selectedColor: $themeColor, color: .red)
              ColorCircleView(selectedColor: $themeColor, color: .green)
              ColorCircleView(selectedColor: $themeColor, color: .blue)
            }
            GridRow {
              ColorCircleView(selectedColor: $themeColor, color: .purple)
              ColorCircleView(selectedColor: $themeColor, color: .yellow)
              ColorCircleView(selectedColor: $themeColor, color: .black)
            }
            GridRow {
              ColorCircleView(selectedColor: $themeColor, color: .brown)
              ColorCircleView(selectedColor: $themeColor, color: .cyan)
              ColorCircleView(selectedColor: $themeColor, color: .indigo)
            }
        }
    }
}

//MARK: - ColorCircleView
struct ColorCircleView: View {
     @Binding var selectedColor: Color
     var color: Color

    var body: some View {
        Circle()
            .fill(selectedColor == color ? .indigo.opacity(0.3) : .clear)
            .frame(width: 100, height: 100)
            .overlay(
                Circle()
                    .fill(color)
                    .frame(width: 80, height: 80)
            )
            .onTapGesture {
                selectedColor = color
            }
            .environment(\.themeColor, color)
    }
}


#Preview {

  struct PreviewWrapper: View {
    @State var color: Color = .green

          var body: some View {
            ThemeColorPaletteView(themeColor: $color)
          }
      }
  return PreviewWrapper()
}


