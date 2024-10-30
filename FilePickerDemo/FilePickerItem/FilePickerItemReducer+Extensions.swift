import Foundation
import SwiftUI

extension FilePickerItemReducer.State {
  func isSizeInvalid(_ state: FilePickerReducer.State) -> Bool {
    guard
      let size,
      let maximumSize = state.maximumSize
    else { return false }

    return size > maximumSize || (state.allItemsSize + size) > maximumSize
  }

  public var image: Image? {
    guard
      let data,
      let uiImage = UIImage(data: data)
    else { return nil }
    return Image(uiImage: uiImage)
  }
}

private extension FilePickerReducer.State {
  var allItemsSize: Int {
    selectedItems.elements
      .compactMap(\.size)
      .reduce(into: 0) { $0 += $1 }
  }
}
