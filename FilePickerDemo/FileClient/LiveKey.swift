import Combine
import ComposableArchitecture
import Foundation

extension FileClient: DependencyKey {
  public static var liveValue: Self {
    .init(
      itemAttributes: { try FileManager.default.attributesOfItem(atPath: $0.path) },
      load: { try Data(contentsOf: $0) }
    )
  }
}
