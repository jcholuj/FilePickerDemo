import Combine
import ComposableArchitecture
import Foundation

public struct FileClient: Sendable {
  public var itemAttributes: @Sendable (URL) async throws -> [FileAttributeKey: Any]
  public var load: @Sendable (URL) async throws -> Data
}

public extension DependencyValues {
  var fileClient: FileClient {
    get { self[FileClient.self] }
    set { self[FileClient.self] = newValue }
  }
}
