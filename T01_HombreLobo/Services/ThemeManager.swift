// Gestió centralitzada del tema visual de l'aplicació (clar / fosc)
import UIKit

// Tema visual disponible
enum AppTheme: String {
    case light = "light"
    case dark  = "dark"

    // Estil d'interfície de UIKit corresponent
    var userInterfaceStyle: UIUserInterfaceStyle {
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

// Singleton que gestiona el tema visual i envia notificacions de canvi
final class ThemeManager {

    static let shared = ThemeManager()
    static let themeChangedNotification = Notification.Name("AppThemeChanged")
    private let themeKey = "selectedAppTheme"

    // Tema actual llegit i guardat a UserDefaults
    var currentTheme: AppTheme {
        get {
            let raw = UserDefaults.standard.string(forKey: themeKey) ?? AppTheme.dark.rawValue
            return AppTheme(rawValue: raw) ?? .dark
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: themeKey)
            applyCurrentTheme()
            NotificationCenter.default.post(name: Self.themeChangedNotification, object: newValue)
        }
    }

    private init() {}

    // Aplica el tema guardat — cridar en iniciar l'app (abans d'usar scenes)
    func applyToWindow(_ window: UIWindow) {
        window.overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
    }

    // Aplica el tema a totes les finestres actives (per als canvis en temps d'execució)
    func applyCurrentTheme() {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                window.overrideUserInterfaceStyle = currentTheme.userInterfaceStyle
            }
        }
    }
}

// MARK: - Paleta de colors adaptativa de l'aplicació

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
