// Servei per carregar i decodificar el fitxer JSON de dades del joc
import Foundation

final class JSONLoaderService {

    // Carrega i retorna les dades del joc des del fitxer data.json del bundle
    static func loadGameData() -> GameData? {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            print("No s'ha trobat el fitxer data.json al bundle")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            return try decoder.decode(GameData.self, from: data)
        } catch {
            print("Error decodificant el fitxer JSON: \(error)")
            return nil
        }
    }
}
