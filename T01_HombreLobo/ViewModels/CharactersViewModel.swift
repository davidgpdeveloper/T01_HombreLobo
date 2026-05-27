// ViewModel per a la pantalla de personatges, seguint el patró MVVM
import Foundation

// Protocol que defineix el contracte de comunicació del ViewModel cap al ViewController
protocol CharactersViewModelDelegate: AnyObject {
    func didLoadCharacters()
}

// ViewModel que gestiona la lògica de negoci de la llista de personatges
final class CharactersViewModel {

    // Delegat per notificar canvis a la vista
    weak var delegate: CharactersViewModelDelegate?

    // Llista de personatges carregats des de Core Data
    private(set) var characters: [CharacterEntity] = []

    // Nombre total de personatges disponibles
    var numberOfCharacters: Int {
        characters.count
    }

    // Carrega els personatges des de Core Data i notifica el delegat
    func loadCharacters() {
        characters = CoreDataService.shared.fetchAllCharacters()
        delegate?.didLoadCharacters()
    }

    // Retorna el personatge per a un índex específic de la llista
    func character(at index: Int) -> CharacterEntity {
        characters[index]
    }
}
