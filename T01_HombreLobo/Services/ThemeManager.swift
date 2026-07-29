// Gestió centralitzada del tema visual de l'aplicació (clar / fosc)
import SwiftUI
import Combine

// Tema visual disponible
enum AppTheme: String {
    case light = "light"
    case dark  = "dark"

    // Esquema de color SwiftUI corresponent
    var colorScheme: ColorScheme {
        self == .dark ? .dark : .light
    }

    // Nom SF Symbol que representa l'estat actual
    var iconName: String {
        self == .dark ? "moon.fill" : "sun.max.fill"
    }

    // Commuta al tema oposat
    var toggled: AppTheme {
        self == .dark ? .light : .dark
    }
}

// Singleton observable que gestiona el tema visual
final class ThemeManager: ObservableObject {

    static let shared = ThemeManager()
    private let themeKey = "selectedAppTheme"

    // Tema actual — notifica SwiftUI via objectWillChange i persiste a UserDefaults
    var currentTheme: AppTheme {
        willSet { objectWillChange.send() }
        didSet  { UserDefaults.standard.set(currentTheme.rawValue, forKey: themeKey) }
    }

    private init() {
        let raw = UserDefaults.standard.string(forKey: "selectedAppTheme") ?? AppTheme.dark.rawValue
        self.currentTheme = AppTheme(rawValue: raw) ?? .dark
    }
}

// MARK: - Paleta de colors UIKit adaptativa

extension UIColor {

    // Fons principal de les pantalles
    static var appBackground: UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1)
                : UIColor(red: 0.96, green: 0.94, blue: 0.91, alpha: 1)
        })
    }

    // Text de títols principals (daurat en fosc, marró fosc en clar)
    static var appTitle: UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.9, green: 0.85, blue: 0.6, alpha: 1)
                : UIColor(red: 0.35, green: 0.2, blue: 0.05, alpha: 1)
        })
    }

    // Text de cos principal
    static var appText: UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.85, green: 0.82, blue: 0.75, alpha: 1)
                : UIColor(red: 0.15, green: 0.12, blue: 0.08, alpha: 1)
        })
    }

    // Text secundari (subtítols, previsualitzacions)
    static var appSubtitle: UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.7, green: 0.65, blue: 0.5, alpha: 1)
                : UIColor(red: 0.45, green: 0.35, blue: 0.2, alpha: 1)
        })
    }

    // Fons de targetes i cel·les individuals
    static var appCardBackground: UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.15, green: 0.1, blue: 0.1, alpha: 1)
                : UIColor(red: 0.99, green: 0.97, blue: 0.94, alpha: 1)
        })
    }

    // Fons de taules agrupades
    static var appTableBackground: UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.08, green: 0.08, blue: 0.12, alpha: 1)
                : .systemGroupedBackground
        })
    }

    // Fons de cel·les de taula
    static var appCellBackground: UIColor {
        UIColor(dynamicProvider: {
            $0.userInterfaceStyle == .dark
                ? UIColor(red: 0.1, green: 0.09, blue: 0.13, alpha: 1)
                : .systemBackground
        })
    }

    // Color d'accent (vermell llop) — igual en ambdós temes
    static var appAccent: UIColor {
        UIColor(red: 0.7, green: 0.2, blue: 0.2, alpha: 1)
    }

    // Color de la icona de lluna/sol
    static var appMoon: UIColor {
        UIColor(red: 0.8, green: 0.7, blue: 0.3, alpha: 1)
    }
}

// MARK: - Paleta de colors SwiftUI (envolta la paleta UIKit)

extension Color {
    static var appBackground:      Color { Color(UIColor.appBackground) }
    static var appTitle:           Color { Color(UIColor.appTitle) }
    static var appText:            Color { Color(UIColor.appText) }
    static var appSubtitle:        Color { Color(UIColor.appSubtitle) }
    static var appCardBackground:  Color { Color(UIColor.appCardBackground) }
    static var appTableBackground: Color { Color(UIColor.appTableBackground) }
    static var appCellBackground:  Color { Color(UIColor.appCellBackground) }
    static var appAccent:          Color { Color(UIColor.appAccent) }
    static var appMoon:            Color { Color(UIColor.appMoon) }
}
