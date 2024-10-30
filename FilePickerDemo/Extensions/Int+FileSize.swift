import Foundation

public extension Int {
  var formattedFileSize: String {
    if self < Constants.bytesInMegaBytes {
      let fileSizeInKB = Double(Swift.max(self, 1)) / Double(Constants.bytesInKiloBytes)
      return "\(Int(ceil(fileSizeInKB))) \(Constants.kiloBytesSuffix)"
    } else {
      let fileSizeInMB = Double(self) / Double(Constants.bytesInMegaBytes)
      return "\(fileSizeInMB.formattedValue) \(Constants.megaBytesSuffix)"
    }
  }
}

private extension Double {
  var formattedValue: String {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    formatter.numberStyle = .decimal
    formatter.roundingMode = .ceiling
    return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
  }
}

private enum Constants {
  static let bytesInKiloBytes = 1_024
  static let bytesInMegaBytes = 1_048_576
  static let kiloBytesSuffix = "KB"
  static let megaBytesSuffix = "MB"
}
