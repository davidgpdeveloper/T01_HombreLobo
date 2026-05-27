// Controlador principal de la barra de pestanyes de l'aplicació
import UIKit

final class MainTabBarController: UITabBarController {

    // MARK: - Cicle de vida

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    // MARK: - Configuració

    // Configura les tres pestanyes de l'aplicació
    private func setupTabs() {
        // Pestanya 1: Pantalla inicial
        let homeVC = HomeViewController()
        homeVC.tabBarItem = UITabBarItem(
            title: "Inici",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )

        // Pestanya 2: Instruccions del joc
        let instructionsVC = InstructionsViewController()
        instructionsVC.tabBarItem = UITabBarItem(
            title: "Instruccions",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )

        // Pestanya 3: Llista de personatges
        let charactersVC = CharactersViewController()
        charactersVC.tabBarItem = UITabBarItem(
            title: "Personatges",
            image: UIImage(systemName: "person.3"),
            selectedImage: UIImage(systemName: "person.3.fill")
        )

        // Embolicar cada controlador en un NavigationController per permetre navegació
        let homeNav = UINavigationController(rootViewController: homeVC)
        let instructionsNav = UINavigationController(rootViewController: instructionsVC)
        let charactersNav = UINavigationController(rootViewController: charactersVC)

        viewControllers = [homeNav, instructionsNav, charactersNav]
    }

    // Configura l'aparença visual de la barra de pestanyes
    private func setupAppearance() {
        // Color principal de l'app: vermell fosc (temàtica de llop)
        let wolfRed = UIColor(red: 0.55, green: 0.05, blue: 0.05, alpha: 1.0)
        tabBar.tintColor = wolfRed

        // Configura l'aparença moderna (iOS 15+)
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.selectionIndicatorTintColor = wolfRed
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
