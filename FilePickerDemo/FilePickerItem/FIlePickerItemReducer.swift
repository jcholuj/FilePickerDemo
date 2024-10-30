import ComposableArchitecture
import Foundation

@Reducer
struct FilePickerItemReducer {
  @ObservableState
  struct State: Equatable, Identifiable {
    let id: UUID
    var name: String?
    var size: Int?
    var url: URL
    var data: Data?
  }

  enum Action: Sendable {
    case removeSelectedItem
  }
}

extension FilePickerItemReducer.State {
  static func == (lhs: FilePickerItemReducer.State, rhs: FilePickerItemReducer.State) -> Bool {
    lhs.name == rhs.name && lhs.size == rhs.size
  }
}
