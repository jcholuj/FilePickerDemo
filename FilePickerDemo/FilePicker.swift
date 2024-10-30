import ComposableArchitecture
import SwiftUI

struct FilePicker: View {
  @Bindable private var store: StoreOf<FilePickerReducer>

  init(store: StoreOf<FilePickerReducer>) {
    self.store = store
  }

  var body: some View {
    WithPerceptionTracking {
      List {
        Section {
          ForEach(store.scope(state: \.selectedItems, action: \.selectedItems)) { store in
            FilePickerItemView(store: store)
          }
        }
        .listRowInsets(.horizontal)

        if self.store.selectedItems.count < self.store.selectionLimit {
          Section(
            content: {
              Button(
                action: { store.send(.addButtonTapped) },
                label: {
                  HStack(alignment: .center, spacing: .spacing200) {
                    Image(systemName: "plus").resizable()
                      .frame(width: .regularIcon, height: .regularIcon)

                    Text("Dodaj plik")
                      .font(.body.weight(.semibold))
                      .multilineTextAlignment(.leading)

                    Spacer()
                  }
                  .foregroundStyle(Color.primary900)
                  .frame(maxWidth: .infinity)
                }
              )
              .padding(.horizontal, 16)
            },
            footer: {
              Text(self.store.tooltipText)
                .font(.footnote)
                .padding(.top, 8)
            }
          )
          .listRowInsets(.zero)
        }
      }
      .environment(\.defaultMinListRowHeight, 76)
      .environment(\.defaultMinListHeaderHeight, 0)
      .listSectionSpacing(.compact)
      .alert(
        self.$store.scope(
          state: \.destination?.alert,
          action: \.destination.alert
        )
      )
      .fileImporter(
        self.$store.scope(
          state: \.destination?.fileImporter,
          action: \.destination.fileImporter
        )
      )
    }
  }
}

private extension EdgeInsets {
  static let zero = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
  static let horizontal = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
}
