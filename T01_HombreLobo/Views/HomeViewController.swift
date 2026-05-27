// Controlador de la pantalla principal (Tab 1)
import UIKit

class HomeViewController: UIViewController {

    // MARK: - Propietats UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let moonImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let dividerView = UIView()
    private let descriptionLabel = UILabel()
    private let infoCardView = UIView()
    private let infoLabel = UILabel()

    // MARK: - Cicle de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLanguageBarButton()
        loadContent()
        // Observa canvis d'idioma i de tema per actualitzar textos i botons
        NotificationCenter.default.addObserver(self,
            selector: #selector(onLanguageChanged),
            name: LanguageManager.languageChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(onThemeChanged),
            name: ThemeManager.themeChangedNotification, object: nil)
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            infoCardView.layer.borderColor = UIColor.appAccent.withAlphaComponent(0.4).cgColor
        }
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - Contingut
    private func loadContent() {
        guard let gameData = JSONLoaderService.loadGameData() else { return }
        let game = gameData.game
        titleLabel.text       = game.title.localized()
        subtitleLabel.text    = game.subtitle.localized()
        descriptionLabel.text = game.description.localized()
        updateTabTitle()
    }

    private func updateTabTitle() {
        switch LanguageManager.shared.currentLanguage {
        case .catalan: title = "Inici"
        case .spanish: title = "Inicio"
        case .english: title = "Home"
        }
        navigationItem.title = title
        tabBarItem.title = title
    }

    @objc private func onLanguageChanged() {
        loadContent()
        setupLanguageBarButton()
    }

    @objc private func onThemeChanged() {
        setupLanguageBarButton()
    }

    // MARK: - Configuració UI
    private func setupUI() {
        view.backgroundColor = .appBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Imatge lluna
        let config = UIImage.SymbolConfiguration(pointSize: 80, weight: .thin)
        moonImageView.image = UIImage(systemName: "moon.stars.fill", withConfiguration: config)
        moonImageView.tintColor = .appMoon
        moonImageView.contentMode = .scaleAspectFit
        moonImageView.translatesAutoresizingMaskIntoConstraints = false

        // Títol
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = .appTitle
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Subtítol
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = .appSubtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Divisor
        dividerView.backgroundColor = .appAccent.withAlphaComponent(0.6)
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        // Descripció
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .appText
        descriptionLabel.textAlignment = .justified
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        // Targeta d'informació
        infoCardView.backgroundColor = .appCardBackground
        infoCardView.layer.cornerRadius = 12
        infoCardView.layer.borderColor = UIColor.appAccent.withAlphaComponent(0.4).cgColor
        infoCardView.layer.borderWidth = 1
        infoCardView.translatesAutoresizingMaskIntoConstraints = false

        infoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        infoLabel.textColor = .appSubtitle
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.text = "🐺"
        infoLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(moonImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(infoCardView)
        infoCardView.addSubview(infoLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            moonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            moonImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moonImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: moonImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            dividerView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            descriptionLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            infoCardView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24),
            infoCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            infoCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            infoCardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),

            infoLabel.topAnchor.constraint(equalTo: infoCardView.topAnchor, constant: 16),
            infoLabel.leadingAnchor.constraint(equalTo: infoCardView.leadingAnchor, constant: 16),
            infoLabel.trailingAnchor.constraint(equalTo: infoCardView.trailingAnchor, constant: -16),
            infoLabel.bottomAnchor.constraint(equalTo: infoCardView.bottomAnchor, constant: -16),
        ])
    }
}
