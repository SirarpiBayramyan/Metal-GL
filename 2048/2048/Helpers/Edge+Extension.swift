
import SwiftUI

extension Edge {

  static func from(_ from: GameViewModel.Direction) -> Self {
    switch from {
    case .down:
      return .top
    case .up:
      return .bottom
    case .left:
      return .trailing
    case .right:
      return .leading
    }
  }

}
