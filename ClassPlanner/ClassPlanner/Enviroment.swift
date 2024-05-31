
import SwiftUI

private struct ThemeColorKey: EnvironmentKey {
    static let defaultValue: Color = Color.blue
}

extension EnvironmentValues {
  var themeColor: Color {
    get { self[ThemeColorKey.self] }
    set { self[ThemeColorKey.self] = newValue }
  }
}
