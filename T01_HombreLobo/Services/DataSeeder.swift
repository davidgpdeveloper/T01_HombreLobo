// Servei per sembrar les dades inicials des del JSON (versió V3 + imatges)
import Foundation

final class DataSeeder {

    // Clau V3: inclou imatges dels personatges
    private static let seededKey = "hasSeededDataV3"

    // Sembra les dades si és la primera vegada o si és una migració V1 → V2
    static func seedIfNeeded() {
        guard !UserDefaults.standard.bool(forKey: seededKey) else { return }

        guard let gameData = JSONLoaderService.loadGameData() else {
            print("Error: no s'ha pogut carregar el JSON de dades")
            return
        }

        // Elimina dades antigues (V1) per evitar duplicats
        CoreDataService.shared.clearAllCharacters()

        // Insereix tots els personatges amb els tres idiomes i la imatge
        for character in gameData.characters {
            CoreDataService.shared.insertCharacter(
                name:               character.name.ca,
                characterDescription: character.description.ca,
                nameEs:             character.name.es,
                nameEn:             character.name.en,
                descriptionEs:      character.description.es,
                descriptionEn:      character.description.en,
                imageName:          character.imageName
            )
        }

        CoreDataService.shared.saveContext()
        UserDefaults.standard.set(true, forKey: seededKey)
        print("Dades sembrades correctament (\(gameData.characters.count) personatges, 3 idiomes)")
    }
}
