// Vista de la pantalla principal (Tab 1) — SwiftUI
import SwiftUI

struct HomeView: View {

    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var gameData: GameData? = nil
    @State private var showingLanguagePicker = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Icona de lluna
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 80, weight: .thin))
                    .foregroundColor(.appMoon)
                    .padding(.top, 30)
                    .padding(.bottom, 16)

                // Títol
                Text(gameData?.game.title.localized(for: languageManager.currentLanguage) ?? "")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.appTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                // Subtítol
                Text(gameData?.game.subtitle.localized(for: languageManager.currentLanguage) ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.appSubtitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                // Divisor
                Rectangle()
                    .fill(Color.appAccent.opacity(0.6))
                    .frame(height: 1)
                    .padding(.horizontal, 40)
                    .padding(.top, 20)

                // Descripció
                Text(gameData?.game.description.localized(for: languageManager.currentLanguage) ?? "")
                    .font(.system(size: 15))
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                // Targeta info
                Text("🐺")
                    .font(.system(size: 24))
                    .padding(16)
                    .frame(maxWidth: .infinity)
                    .background(Color.appCardBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.appAccent.opacity(0.4), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 30)
            }
        }
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
        .onAppear { gameData = JSONLoaderService.loadGameData() }
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
        case .catalan: return "Inici"
        case .spanish: return "Inicio"
        case .english: return "Home"
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
