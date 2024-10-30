import ComposableArchitecture
import SwiftUI

struct FilePickerItemView: View {
  let store: StoreOf<FilePickerItemReducer>

  var body: some View {
    WithPerceptionTracking {
      HStack(spacing: .spacing200) {
        Group {
          if let data = store.data, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
              .resizable()
              .aspectRatio(contentMode: .fill)
              .frame(width: Constants.leadingItemSize, height: Constants.leadingItemSize)
          } else {
            Image(systemName: "document")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: .regularIcon, height: .regularIcon)
              .padding(Constants.fileIconPadding)
              .foregroundStyle(.gray)
              .background(Color.gray.opacity(0.15))
          }
        }
        .clipShape(.rect(cornerRadius: .radius150))

        if
          let name = self.store.name,
          let size = self.store.size
        {
          VStack(alignment: .leading, spacing: .spacing100) {
            Text(name)
              .font(.body.weight(.semibold))

            Text(size.formattedFileSize)
              .foregroundStyle(.gray)
              .font(.footnote)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .lineLimit(2)
        }

        Spacer()

        Button(
          action: { self.store.send(.removeSelectedItem) },
          label: {
            Image(systemName: "trash")
              .resizable()
              .frame(width: .regularIcon, height: .regularIcon)
              .foregroundStyle(.red)
          }
        )
      }
      .frame(maxWidth: .infinity)
    }
  }
}

private enum Constants {
  static let leadingItemSize = 44.0
  static let fileIconPadding = 14.0
}
