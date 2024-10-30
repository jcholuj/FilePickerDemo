import SwiftUI

extension View {
  func contentBox() -> some View {
    modifier(ContentBoxModifier())
  }
}

private struct ContentBoxModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding(.spacing200)
      .frame(maxWidth: .infinity, minHeight: 76.0)
      .background(.white)
      .clipShape(.rect(cornerRadius: .radius200))
  }
}
