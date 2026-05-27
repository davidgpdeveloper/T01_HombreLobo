// Controlador de la pantalla d'instruccions (Tab 2)
import UIKit

class InstructionsViewController: UIViewController {

    // MARK: - Propietats
    private var sections: [InstructionSection] = []
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // MARK: - Cicle de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLanguageBarButton()
        loadInstructions()
        NotificationCenter.default.addObserver(self,
            selector: #selector(onLanguageChanged),
            name: LanguageManager.languageChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(onThemeChanged),
            name: ThemeManager.themeChangedNotification, object: nil)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - Contingut
    private func loadInstructions() {
        guard let gameData = JSONLoaderService.loadGameData() else { return }
        sections = gameData.instructions
        updateTitle()
        tableView.reloadData()
    }

    private func updateTitle() {
        switch LanguageManager.shared.currentLanguage {
        case .catalan: title = "Instruccions"
        case .spanish: title = "Instrucciones"
        case .english: title = "Instructions"
        }
        navigationItem.title = title
        tabBarItem.title = title
    }

    @objc private func onLanguageChanged() {
        loadInstructions()
        setupLanguageBarButton()
    }

    @objc private func onThemeChanged() {
        setupLanguageBarButton()
        // Actualitza colors de les cel·les visibles
        tableView.backgroundColor = .appTableBackground
        view.backgroundColor = .appTableBackground
        tableView.reloadData()
    }

    // MARK: - Configuració UI
    private func setupUI() {
        view.backgroundColor = .appTableBackground
        tableView.backgroundColor = .appTableBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - UITableViewDataSource & Delegate
extension InstructionsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int { sections.count }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title.localized()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = sections[indexPath.section].content.localized()
        content.textProperties.numberOfLines = 0
        content.textProperties.color = .appText
        cell.contentConfiguration = content
        cell.backgroundColor = .appCardBackground
        cell.selectionStyle = .none
        return cell
    }
}
