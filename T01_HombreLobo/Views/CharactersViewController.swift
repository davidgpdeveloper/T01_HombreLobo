// Controlador de la pantalla de personatges (Tab 3)
import UIKit

class CharactersViewController: UIViewController {

    // MARK: - Propietats
    private let viewModel = CharactersViewModel()
    private let tableView = UITableView()

    // MARK: - Cicle de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLanguageBarButton()
        viewModel.delegate = self
        viewModel.loadCharacters()
        updateTitle()
        NotificationCenter.default.addObserver(self,
            selector: #selector(onLanguageChanged),
            name: LanguageManager.languageChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(onThemeChanged),
            name: ThemeManager.themeChangedNotification, object: nil)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - Idioma i tema
    private func updateTitle() {
        switch LanguageManager.shared.currentLanguage {
        case .catalan: title = "Personatges"
        case .spanish: title = "Personajes"
        case .english: title = "Characters"
        }
        navigationItem.title = title
        tabBarItem.title = title
    }

    @objc private func onLanguageChanged() {
        updateTitle()
        setupLanguageBarButton()
        tableView.reloadData()
    }

    @objc private func onThemeChanged() {
        setupLanguageBarButton()
        tableView.backgroundColor = .appBackground
        view.backgroundColor = .appBackground
        tableView.reloadData()
    }

    // MARK: - Configuració UI
    private func setupUI() {
        view.backgroundColor = .appBackground
        tableView.backgroundColor = .appBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CharacterCell.self, forCellReuseIdentifier: CharacterCell.reuseIdentifier)
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

// MARK: - CharactersViewModelDelegate
extension CharactersViewController: CharactersViewModelDelegate {
    func didLoadCharacters() {
        DispatchQueue.main.async { self.tableView.reloadData() }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfCharacters
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: CharacterCell.reuseIdentifier, for: indexPath) as! CharacterCell
        cell.configure(with: viewModel.character(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 80 }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = CharacterDetailViewController(character: viewModel.character(at: indexPath.row))
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
