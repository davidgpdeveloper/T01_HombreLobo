// Controlador del detall d'un personatge
import UIKit

class CharacterDetailViewController: UIViewController {

    // MARK: - Propietats
    private let character: CharacterEntity

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dividerView = UIView()
    private let descriptionLabel = UILabel()

    // MARK: - Inicialitzador
    init(character: CharacterEntity) {
        self.character = character
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no implementat") }

    // MARK: - Cicle de vida
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
        NotificationCenter.default.addObserver(self,
            selector: #selector(onLanguageChanged),
            name: LanguageManager.languageChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self,
            selector: #selector(onThemeChanged),
            name: ThemeManager.themeChangedNotification, object: nil)
    }

    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - Dades localitzades
    private func populateData() {
        title = character.localizedName()
        nameLabel.text = character.localizedName()
        descriptionLabel.text = character.localizedDescription()

        // Mostra la imatge real del personatge si existeix, o la icona SF per defecte
        if let imgName = character.imageName,
           let img = UIImage(named: "Characters/\(imgName)") {
            iconImageView.image = img
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.tintColor = nil
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .thin)
            iconImageView.image = UIImage(systemName: "person.fill", withConfiguration: config)
            iconImageView.contentMode = .scaleAspectFit
            iconImageView.tintColor = .appAccent
        }
    }

    @objc private func onLanguageChanged() { populateData() }

    @objc private func onThemeChanged() {
        view.backgroundColor = .appBackground
        nameLabel.textColor = .appTitle
        descriptionLabel.textColor = .appText
    }

    // MARK: - Configuració UI
    private func setupUI() {
        view.backgroundColor = .appBackground

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        // Icona / imatge del personatge
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = 12
        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        // Nom del personatge
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .appTitle
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Divisor
        dividerView.backgroundColor = .appAccent.withAlphaComponent(0.6)
        dividerView.translatesAutoresizingMaskIntoConstraints = false

        // Descripció
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = .appText
        descriptionLabel.textAlignment = .justified
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(iconImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dividerView)
        contentView.addSubview(descriptionLabel)

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

            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.65),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1.4),

            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            dividerView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            dividerView.heightAnchor.constraint(equalToConstant: 1),

            descriptionLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
        ])
    }
}
