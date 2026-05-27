// Cel·la personalitzada per a la llista de personatges
import UIKit

class CharacterCell: UITableViewCell {

    static let reuseIdentifier = "CharacterCell"

    // MARK: - UI
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .appTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let previewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .appSubtitle
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let wolfIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        imageView.tintColor = .appAccent
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Inicialitzador
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .appCellBackground
        accessoryType = .disclosureIndicator
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) no implementat") }

    // MARK: - Configuració
    func configure(with character: CharacterEntity) {
        nameLabel.text    = character.localizedName()
        previewLabel.text = character.localizedDescription()

        // Imatge real del personatge o icona per defecte
        if let imgName = character.imageName,
           let img = UIImage(named: "Characters/\(imgName)") {
            wolfIcon.image = img
        } else {
            let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
            wolfIcon.image = UIImage(systemName: "person.fill", withConfiguration: config)
        }
    }

    // MARK: - Layout
    private func setupLayout() {
        contentView.addSubview(wolfIcon)
        contentView.addSubview(nameLabel)
        contentView.addSubview(previewLabel)

        NSLayoutConstraint.activate([
            wolfIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            wolfIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            wolfIcon.widthAnchor.constraint(equalToConstant: 44),
            wolfIcon.heightAnchor.constraint(equalToConstant: 56),

            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: wolfIcon.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            previewLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            previewLabel.leadingAnchor.constraint(equalTo: wolfIcon.trailingAnchor, constant: 12),
            previewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            previewLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
        ])
    }
}
