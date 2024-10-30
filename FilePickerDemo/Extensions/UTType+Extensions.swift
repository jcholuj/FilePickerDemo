import UniformTypeIdentifiers

extension UTType {
  var displayedName: String? {
    preferredFilenameExtension.map { ".\($0)" }
  }
}
