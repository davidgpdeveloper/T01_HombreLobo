// Servei singleton per a la gestió de Core Data
import Foundation
import CoreData

final class CoreDataService {

    static let shared = CoreDataService()
    private init() {}

    // Contenidor persistent de Core Data amb migració automàtica lleugera
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "T01_HombreLobo")
        // Opcions de migració lleugera per suportar canvis de model sense pèrdua de dades
        let description = container.persistentStoreDescriptions.first
        description?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        description?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error carregant Core Data: \(error)")
            }
        }
        return container
    }()

    // Context principal de l'aplicació
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Insereix un personatge amb tots els camps multilingüe i la imatge
    func insertCharacter(name: String, characterDescription: String,
                         nameEs: String, nameEn: String,
                         descriptionEs: String, descriptionEn: String,
                         imageName: String? = nil) {
        let entity = CharacterEntity(context: context)
        entity.name = name
        entity.characterDescription = characterDescription
        entity.nameEs = nameEs
        entity.nameEn = nameEn
        entity.descriptionEs = descriptionEs
        entity.descriptionEn = descriptionEn
        entity.imageName = imageName
    }

    // Retorna tots els personatges emmagatzemats
    func fetchAllCharacters() -> [CharacterEntity] {
        let request = CharacterEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            print("Error obtenint personatges: \(error)")
            return []
        }
    }

    // Comprova si ja hi ha personatges a la base de dades
    func hasCharacters() -> Bool {
        let request = CharacterEntity.fetchRequest()
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }

    // Elimina tots els personatges de la base de dades
    func clearAllCharacters() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CharacterEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error eliminant personatges: \(error)")
        }
    }

    // Desa els canvis al context
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Error desant context: \(error)")
        }
    }
}
