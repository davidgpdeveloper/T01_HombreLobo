// Fila de personatge per a la llista (SwiftUI)
import SwiftUI

struct CharacterRowView: View {

    @EnvironmentObject var languageManager: LanguageManager
    let character: CharacterEntity

    var body: some View {
        HStack(spacing: 12) {
            // Imatge o icona del personatge
            characterThumbnail
                .frame(width: 44, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 6))

            VStack(alignment: .leading, spacing: 4) {
                Text(character.localizedName(language: languageManager.currentLanguage))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.appTitle)

                Text(character.localizedDescription(language: languageManager.currentLanguage))
                    .font(.system(size: 13))
                    .foregroundColor(.appSubtitle)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }

    @ViewBuilder
    private var characterThumbnail: some View {
        if let imgName = character.imageName,
           let uiImage = UIImage(named: "Characters/\(imgName)") {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            Image(systemName: "person.fill")
                .font(.system(size: 24, weight: .light))
                .foregroundColor(.appAccent)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
