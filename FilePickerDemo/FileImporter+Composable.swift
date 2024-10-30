import ComposableArchitecture
import Foundation
import SwiftUI
import UniformTypeIdentifiers

public struct FileImporterState: Identifiable {
  public let id: UUID
  public let allowedContentTypes: [UTType]?
  public let allowsMultipleSelection: Bool

  public init(
    allowedContentTypes: [UTType]?,
    allowsMultipleSelection: Bool,
    id: UUID
  ) {
    self.id = id
    self.allowedContentTypes = allowedContentTypes
    self.allowsMultipleSelection = allowsMultipleSelection
  }
}

public enum FileImporterAction: Equatable {
  case success([URL])
  case failure
}

extension FileImporterState: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id && lhs.allowedContentTypes == rhs.allowedContentTypes
  }
}

extension FileImporterState: _EphemeralState {
  public typealias Action = FileImporterAction
}

extension View {
#if swift(<5.10)
  @MainActor(unsafe)
#else
  @preconcurrency@MainActor
#endif
  public func fileImporter(_ item: Binding<Store<FileImporterState, FileImporterAction>?>) -> some View {
    let store = item.wrappedValue
    let alertState = store?.withState { $0 }

    return self.fileImporter(
      isPresented: Binding(item),
      allowedContentTypes: alertState?.allowedContentTypes ?? [.pdf],
      allowsMultipleSelection: alertState?.allowsMultipleSelection ?? false,
      onCompletion: { result in
        switch result {
        case let .success(urls):
          store?.send(.success(urls))

        case .failure:
          store?.send(.failure)
        }
      }
    )
  }
}
