// Gestió centralitzada de l'idioma de l'aplicació
import Foundation
import Combine

// Enumeració amb els idiomes suportats per l'aplicació
enum AppLanguage: String, CaseIterable {
    case catalan = "ca"
    case spanish = "es"
    case english = "en"

    var displayName: String {
        switch self {
        case .catalan: return "Català"
        case .spanish: return "Español"
        case .english: return "English"
        }
    }

    var flagEmoji: String {
        switch self {
        case .catalan: return "🏴 CA"
        case .spanish: return "🇪🇸"
        case .english: return "🇬🇧"
        }
    }

    var barButtonTitle: String {
        switch self {
        case .catalan: return "CA"
        case .spanish: return "🇪🇸"
        case .english: return "🇬🇧"
        }
    }
}

final class LanguageManager: ObservableObject {

    static let shared = LanguageManager()
    private let languageKey = "selectedAppLanguage"

    var currentLanguage: AppLanguage {
        willSet { objectWillChange.send() }
        didSet   { UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey) }
    }

    private init() {
        let raw = UserDefaults.standard.string(forKey: "selectedAppLanguage") ?? AppLanguage.catalan.rawValue
        self.currentLanguage = AppLanguage(rawValue: raw) ?? .catalan
    }
}
