import Combine
import ComposableArchitecture
import SwiftUI
import UIKit
import UniformTypeIdentifiers

@Reducer
struct FilePickerReducer {
  @ObservableState
  struct State: Equatable {
    var compressionQuality: CGFloat
    var selectedItems: IdentifiedArrayOf<FilePickerItemReducer.State>
    let selectionLimit: Int
    let maximumSize: Int?
    let allowedContentTypes: [UTType]?
    @Presents var destination: Destination.State?

    init(
      selectionLimit: Int = 1,
      maximumSize: Int? = nil,
      destination: Destination.State? = nil,
      compressionQuality: CGFloat = 1.0,
      allowedContentTypes: [UTType]? = nil,
      selectedItems: IdentifiedArrayOf<FilePickerItemReducer.State> = .init()
    ) {
      self.selectionLimit = selectionLimit
      self.maximumSize = maximumSize
      self.destination = destination
      self.compressionQuality = compressionQuality
      self.allowedContentTypes = allowedContentTypes
      self.selectedItems = selectedItems
    }
  }

  enum Action: BindableAction {
    case fileSelected(FilePickerItemReducer.State)
    case addButtonTapped
    case binding(BindingAction<State>)
    case delegate(Delegate)
    case destination(PresentationAction<Destination.Action>)
    case selectedItems(IdentifiedActionOf<FilePickerItemReducer>)

    @CasePathable
    enum Delegate: Equatable {
      case didCancel
    }
  }

  @Dependency(\.fileClient) private var fileClient
  @Dependency(\.uuid) private var uuid

  var body: some Reducer<State, Action> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .addButtonTapped:
        state.destination = .fileImporter(
          .init(
            allowedContentTypes: state.allowedContentTypes,
            allowsMultipleSelection: state.currentSelectionLimit > 1,
            id: uuid()
          )
        )
        return .none

      case let .selectedItems(.element(id: id, action: .removeSelectedItem)):
        state.selectedItems.remove(id: id)
        return .none

      case var .fileSelected(item):
        handleSelectedItem(&state, item: &item)
        return .none

      case let .destination(.presented(.fileImporter(.success(urls)))):
        return .run { send in
          for url in urls {
            _ = url.startAccessingSecurityScopedResource()
            let item = try await FilePickerItemReducer.State(
              id: uuid(),
              name: url.lastPathComponent,
              size: self.fileClient.itemAttributes(url).size,
              url: url,
              data: self.fileClient.load(url)
            )
            url.stopAccessingSecurityScopedResource()
            await send(.fileSelected(item))
          }
        }

      case .destination(.presented(.fileImporter(.failure))):
        state.destination = nil
        return .send(.delegate(.didCancel))

      case .binding:
        return .none

      case .delegate:
        return .none

      case .destination:
        return .none

      case .selectedItems:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
    .forEach(\.selectedItems, action: \.selectedItems) {
      FilePickerItemReducer()
    }
  }
}

extension FilePickerReducer {
  @Reducer(state: .equatable)
  enum Destination {
    case alert(AlertState<Never>)
    @ReducerCaseEphemeral
    case fileImporter(FileImporterState)
  }
}

extension FilePickerReducer.State {
  var currentSelectionLimit: Int {
    selectionLimit > selectedItems.count
      ? selectionLimit - selectedItems.count
      : .zero
  }

  var tooltipText: String {
    var tooltipMessages: [String] = []
    if let allowedContentTypes {
      let formats = allowedContentTypes.compactMap(\.displayedName).joined(separator: ", ")
      tooltipMessages.append("Dopuszczalne formaty: \(formats).")
    }

    if let maximumSize {
      tooltipMessages.append(
        selectionLimit > 1
          ? "Maksymalny rozmiar plików: \(maximumSize.formattedFileSize)."
          : "Maksymalny rozmiar pliku: \(maximumSize.formattedFileSize)."
      )
    }

    if selectionLimit > 1 {
      tooltipMessages.append("Dopuszczalna liczba plików: \(selectionLimit).")
    }

    return tooltipMessages.joined(separator: " ")
  }
}

private extension FilePickerReducer {
  func handleSelectedItem(
    _ state: inout State,
    item: inout FilePickerItemReducer.State
  ) {
    guard !state.selectedItems.contains(where: { $0 == item })
    else {
      state.destination = .alert(.alreadyAdded)
      return
    }

    if item.isSizeInvalid(state) {
      state.destination = .alert(
        .invalidSize(
          maximumSize: state.maximumSize,
          allowsMultipleSelection: state.selectionLimit > 1
        )
      )
    }

    if state.selectedItems.count >= state.selectionLimit {
      state.destination = .alert(
        .selectionLimit(limitNumber: state.selectionLimit)
      )
    }

    state.selectedItems.append(item)
  }
}

private extension Dictionary where Key == FileAttributeKey {
  var size: Int? {
    guard let size = self[FileAttributeKey.size] as? NSNumber
    else { return nil }
    return size.intValue
  }
}
