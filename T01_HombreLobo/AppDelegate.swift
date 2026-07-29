// Punt d'entrada SwiftUI de l'aplicació
import SwiftUI

@main
struct T01HombreLoboApp: App {

    @StateObject private var languageManager = LanguageManager.shared
    @StateObject private var themeManager   = ThemeManager.shared

    init() {
        DataSeeder.seedIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(languageManager)
                .environmentObject(themeManager)
                .preferredColorScheme(themeManager.currentTheme.colorScheme)
        }
    }
}
