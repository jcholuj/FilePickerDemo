import Combine
import ComposableArchitecture
import Foundation

extension FileClient: TestDependencyKey {
  public static let testValue = Self(
    itemAttributes: unimplemented("\(Self.self).itemAttributes"),
    load: unimplemented("\(Self.self).load")
  )
}
