import ComposableArchitecture

extension AlertState {
  static var alreadyAdded: AlertState<Action> {
    .init(
      title: { .init("Ten plik został już dodany") },
      actions: {
        .init(
          role: .cancel,
          label: { .init("Zamknij") })
      },
      message: { .init("Dodaj inny plik.") }
    )
  }

  static func invalidSize(
    maximumSize: Int?,
    allowsMultipleSelection: Bool
  ) -> AlertState<Action> {
    let maximumSizeFormatted = (maximumSize ?? 0).formattedFileSize

    return .init(
      title: { .init("Plik jest za duży") },
      actions: { .init(role: .cancel, label: { .init("Zamknij") }) },
      message: {
        .init(
          allowsMultipleSelection
            ? "Wszystkie pliki mogą mieć łącznie \(maximumSizeFormatted)."
            : "Dodaj plik, który ma maksymalnie \(maximumSizeFormatted)."
        )
      }
    )
  }

  static func selectionLimit(limitNumber: Int) -> AlertState<Action> {
    .init(
      title: { .init("Przekroczono dopuszczalną liczbę plików") },
      actions: { .init(role: .cancel, label: { .init("Zamknij") }) },
      message: { .init("Liczba plików, które możesz dodać: \(limitNumber).") }
    )
  }
}
