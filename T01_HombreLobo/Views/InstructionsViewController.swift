// Vista de la pantalla d'instruccions (Tab 2) — SwiftUI
import SwiftUI

struct InstructionsView: View {

    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var sections: [InstructionSection] = []
    @State private var showingLanguagePicker = false

    var body: some View {
        List {
            ForEach(sections.indices, id: \.self) { idx in
                Section(header:
                    Text(sections[idx].title.localized(for: languageManager.currentLanguage))
                ) {
                    Text(sections[idx].content.localized(for: languageManager.currentLanguage))
                        .font(.system(size: 15))
                        .foregroundColor(.appText)
                        .listRowBackground(Color.appCardBackground)
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(Color.appTableBackground.ignoresSafeArea())
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
        .onAppear { sections = JSONLoaderService.loadGameData()?.instructions ?? [] }
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
        case .catalan: return "Instruccions"
        case .spanish: return "Instrucciones"
        case .english: return "Instructions"
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
