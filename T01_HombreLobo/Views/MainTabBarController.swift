// Vista principal de la barra de pestanyes (SwiftUI)
import SwiftUI

struct MainTabView: View {

    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label(homeTitle, systemImage: "house")
            }

            NavigationStack {
                InstructionsView()
            }
            .tabItem {
                Label(instructionsTitle, systemImage: "book")
            }

            NavigationStack {
                CharactersView()
            }
            .tabItem {
                Label(charactersTitle, systemImage: "person.3")
            }
        }
        .tint(Color(red: 0.55, green: 0.05, blue: 0.05))
    }

    private var homeTitle: String {
        switch languageManager.currentLanguage {
        case .catalan: return "Inici"
        case .spanish: return "Inicio"
        case .english: return "Home"
        }
    }

    private var instructionsTitle: String {
        switch languageManager.currentLanguage {
        case .catalan: return "Instruccions"
        case .spanish: return "Instrucciones"
        case .english: return "Instructions"
        }
    }

    private var charactersTitle: String {
        switch languageManager.currentLanguage {
        case .catalan: return "Personatges"
        case .spanish: return "Personajes"
        case .english: return "Characters"
        }
    }
}

