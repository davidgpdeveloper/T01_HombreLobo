// ViewModel per a la pantalla de personatges, seguint el patró MVVM amb SwiftUI
import Foundation
import Combine

// ViewModel observable que gestiona la lògica de negoci de la llista de personatges
final class CharactersViewModel: ObservableObject {

    // Llista de personatges carregats des de Core Data, observable per SwiftUI
    @Published private(set) var characters: [CharacterEntity] = []

    // Carrega els personatges des de Core Data
    func loadCharacters() {
        characters = CoreDataService.shared.fetchAllCharacters()
    }
}

