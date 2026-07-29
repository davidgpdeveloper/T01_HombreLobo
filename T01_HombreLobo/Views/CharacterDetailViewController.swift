// Vista del detall d'un personatge — SwiftUI
import SwiftUI

struct CharacterDetailView: View {

    @EnvironmentObject var languageManager: LanguageManager
    let character: CharacterEntity

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                // Imatge del personatge (65% amplada, proporció retrat)
                characterImage
                    .padding(.horizontal, 48)
                    .padding(.top, 20)

                // Nom
                Text(character.localizedName(language: languageManager.currentLanguage))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.appTitle)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                // Divisor
                Rectangle()
                    .fill(Color.appAccent.opacity(0.6))
                    .frame(height: 1)
                    .padding(.horizontal, 40)
                    .padding(.top, 16)

                // Descripció
                Text(character.localizedDescription(language: languageManager.currentLanguage))
                    .font(.system(size: 15))
                    .foregroundColor(.appText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 30)
            }
        }
        .background(Color.appBackground.ignoresSafeArea())
        .navigationTitle(character.localizedName(language: languageManager.currentLanguage))
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var characterImage: some View {
        if let imgName = character.imageName,
           let uiImage = UIImage(named: "Characters/\(imgName)") {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 12))
        } else {
            Image(systemName: "person.fill")
                .font(.system(size: 60, weight: .thin))
                .foregroundColor(.appAccent)
                .frame(maxWidth: .infinity, minHeight: 160)
        }
    }
}
