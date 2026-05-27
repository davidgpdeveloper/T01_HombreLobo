// Gestió centralitzada de l'idioma de l'aplicació
import UIKit

// Enumeració amb els idiomes suportats per l'aplicació
enum AppLanguage: String, CaseIterable {
    case catalan = "ca"
    case spanish = "es"
    case english = "en"

    // Nom visible de l'idioma en el seu propi idioma
    var displayName: String {
        switch self {
        case .catalan: return "Català"
        case .spanish: return "Español"
        case .english: return "English"
        }
    }

    // Emoji de bandera per mostrar a la interfície
    var flagEmoji: String {
        switch self {
        case .catalan: return "🏴 CA"
        case .spanish: return "🇪🇸"
        case .english: return "🇬🇧"
        }
    }

    // Títol curt per al botó de la barra de navegació
    var barButtonTitle: String {
        switch self {
        case .catalan: return "CA"
        case .spanish: return "🇪🇸"
        case .english: return "🇬🇧"
        }
    }
}

// Singleton que gestiona l'idioma seleccionat i envia notificacions de canvi
final class LanguageManager {

    // Instància compartida (patró Singleton)
    static let shared = LanguageManager()

    // Nom de la notificació que s'emet quan es canvia d'idioma
    static let languageChangedNotification = Notification.Name("AppLanguageChanged")

    // Clau de UserDefaults per persistir l'idioma seleccionat
    private let languageKey = "selectedAppLanguage"

    // Idioma actual, llegit i guardat a UserDefaults
    var currentLanguage: AppLanguage {
        get {
            let raw = UserDefaults.standard.string(forKey: languageKey) ?? AppLanguage.catalan.rawValue
            return AppLanguage(rawValue: raw) ?? .catalan
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: languageKey)
            // Notifica totes les vistes que l'idioma ha canviat
            NotificationCenter.default.post(name: Self.languageChangedNotification, object: newValue)
        }
    }

    private init() {}
}

// MARK: - Extensió UIViewController per al selector d'idioma

// Extensió que afegeix la funcionalitat del botó de canvi d'idioma a qualsevol ViewController
extension UIViewController {

    // Afegeix o actualitza els botons de selecció d'idioma i tema a la barra de navegació
    func setupLanguageBarButton() {
        let lang = LanguageManager.shared.currentLanguage
        let theme = ThemeManager.shared.currentTheme

        // Botó d'idioma (més a la dreta)
        let languageButton = UIBarButtonItem(
            title: lang.barButtonTitle,
            style: .plain,
            target: self,
            action: #selector(presentLanguagePicker)
        )
        languageButton.accessibilityLabel = "Canviar idioma"

        // Botó de tema clar/fosc (sol o lluna)
        let themeButton = UIBarButtonItem(
            image: UIImage(systemName: theme.iconName),
            style: .plain,
            target: self,
            action: #selector(toggleTheme)
        )
        themeButton.accessibilityLabel = "Canviar tema"

        // Ordre: languageButton (dreta) → themeButton (esquerra)
        navigationItem.rightBarButtonItems = [languageButton, themeButton]
    }

    // Commuta entre tema clar i fosc
    @objc func toggleTheme() {
        ThemeManager.shared.currentTheme = ThemeManager.shared.currentTheme.toggled
    }

    // Mostra un action sheet per seleccionar l'idioma
    @objc func presentLanguagePicker() {
        let current = LanguageManager.shared.currentLanguage

        // Títol de l'action sheet en l'idioma actual
        let alertTitle: String
        switch current {
        case .catalan: alertTitle = "Selecciona l'idioma"
        case .spanish: alertTitle = "Seleccionar idioma"
        case .english: alertTitle = "Select language"
        }

        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)

        // Afegeix una opció per a cada idioma disponible
        for language in AppLanguage.allCases {
            let isSelected = language == current
            // Afegeix una marca de selecció a l'idioma actiu
            let title = isSelected ? "✓ \(language.flagEmoji) \(language.displayName)" : "\(language.flagEmoji) \(language.displayName)"
            let action = UIAlertAction(title: title, style: .default) { _ in
                LanguageManager.shared.currentLanguage = language
            }
            alert.addAction(action)
        }

        // Botó de cancel·lació
        let cancelTitle: String
        switch current {
        case .catalan: cancelTitle = "Cancel·lar"
        case .spanish: cancelTitle = "Cancelar"
        case .english: cancelTitle = "Cancel"
        }
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel))

        // Configuració del popover per a iPad (usa el botó d'idioma, el primer de la dreta)
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = navigationItem.rightBarButtonItems?.first
        }

        present(alert, animated: true)
    }
}
