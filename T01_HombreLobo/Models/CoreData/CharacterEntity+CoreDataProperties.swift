// Propietats i mètodes helpers de l'entitat CharacterEntity per a multilingüisme
import Foundation
import CoreData

extension CharacterEntity {

    // Petició de cerca per a l'entitat CharacterEntity
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    // Nom del personatge en català (idioma per defecte)
    @NSManaged public var name: String?

    // Descripció del personatge en català (idioma per defecte)
    @NSManaged public var characterDescription: String?

    // Nom del personatge en castellà
    @NSManaged public var nameEs: String?

    // Nom del personatge en anglès
    @NSManaged public var nameEn: String?

    // Descripció del personatge en castellà
    @NSManaged public var descriptionEs: String?

    // Descripció del personatge en anglès
    @NSManaged public var descriptionEn: String?

    // Nom de l'asset de la imatge del personatge
    @NSManaged public var imageName: String?

    // Retorna el nom localitzat segons l'idioma indicat
    func localizedName(language: AppLanguage = LanguageManager.shared.currentLanguage) -> String {
        switch language {
        case .catalan:  return name ?? ""
        case .spanish:  return nameEs ?? name ?? ""
        case .english:  return nameEn ?? name ?? ""
        }
    }

    // Retorna la descripció localitzada segons l'idioma indicat
    func localizedDescription(language: AppLanguage = LanguageManager.shared.currentLanguage) -> String {
        switch language {
        case .catalan:  return characterDescription ?? ""
        case .spanish:  return descriptionEs ?? characterDescription ?? ""
        case .english:  return descriptionEn ?? characterDescription ?? ""
        }
    }
}

// Conformitat amb Identifiable per facilitar l'ús en llistes
extension CharacterEntity: Identifiable {}
