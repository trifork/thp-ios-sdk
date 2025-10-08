import Foundation

extension Locale {
    public static var applicationLocale: Locale {
        Bundle.main.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
    }
}
