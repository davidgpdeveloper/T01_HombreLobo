// Vista de la pantalla de personatges (Tab 3) — SwiftUI
import SwiftUI

struct CharactersView: View {

    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var viewModel = CharactersViewModel()
    @State private var showingLanguagePicker = false

    var body: some View {
        List(viewModel.characters) { character in
            NavigationLink(destination: CharacterDetailView(character: character)) {
                CharacterRowView(character: character)
            }
            .listRowBackground(Color.appCellBackground)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .confirmationDialog(pickerTitle, isPresented: $showingLanguagePicker, titleVisibility: .visible) {
            ForEach(AppLanguage.allCases, id: \.self) { lang in
                Button("\(lang.flagEmoji) \(lang.displayName)") {
                    languageManager.currentLanguage = lang
                }
            }
            Button(cancelTitle, role: .cancel) {}
        }
        .onAppear { viewModel.loadCharacters() }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack(spacing: 12) {
                Button {
                    themeManager.currentTheme = themeManager.currentTheme.toggled
                } label: {
                    Image(systemName: themeManager.currentTheme.iconName)
                }
                Button(languageManager.currentLanguage.barButtonTitle) {
                    showingLanguagePicker = true
                }
            }
        }
    }

    private var navigationTitle: String {
        switch languageManager.currentLanguage {
        case .catalan: return "Personatges"
        case .spanish: return "Personajes"
        case .english: return "Characters"
        }
    }

    private var pickerTitle: String {
        switch languageManager.currentLanguage {
        case .catalan: return "Selecciona l'idioma"
        case .spanish: return "Seleccionar idioma"
        case .english: return "Select language"
        }
    }

    private var cancelTitle: String {
        switch languageManager.currentLanguage {
        case .catalan: return "Cancel·lar"
        case .spanish: return "Cancelar"
        case .english: return "Cancel"
        }
    }
}
