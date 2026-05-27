// Gestió del cicle de vida de l'escena (finestra) de l'aplicació
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Crea la finestra principal i estableix el TabBarController com a arrel
        let window = UIWindow(windowScene: windowScene)
        // Aplica el tema guardat (clar/fosc) abans de mostrar la finestra
        ThemeManager.shared.applyToWindow(window)
        window.rootViewController = MainTabBarController()
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Guarda el context de Core Data quan l'app passa al segon pla
        CoreDataService.shared.saveContext()
    }
}
