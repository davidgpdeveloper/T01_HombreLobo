// Models de dades per descodificar el JSON del joc
import Foundation

// Cadena localitzada en tres idiomes
struct LocalizedString: Decodable {
    let ca: String
    let es: String
    let en: String

    // Retorna el text en l'idioma actual de l'aplicacio
    func localized(for language: AppLanguage = LanguageManager.shared.currentLanguage) -> String {
        switch language {
        case .catalan: return ca
        case .spanish: return es
        case .english: return en
        }
    }
}

// Arrel del JSON
struct GameData: Decodable {
    let game: GameInfo
    let instructions: [InstructionSection]
    let characters: [CharacterData]
}

// Informacio general del joc (portada)
struct GameInfo: Decodable {
    let title: LocalizedString
    let subtitle: LocalizedString
    let description: LocalizedString
}

// Seccio d'instruccions
struct InstructionSection: Decodable {
    let title: LocalizedString
    let content: LocalizedString
}

// Dades d'un personatge
struct CharacterData: Decodable {
    let name: LocalizedString
    let description: LocalizedString
    let imageName: String?
}
