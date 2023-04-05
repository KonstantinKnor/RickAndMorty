

import UIKit

final class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifer = "RMCharacterInfoCollectionViewCell"
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .light)
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    private let iconImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    private let titleContenerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubviews(valueLabel, iconImageView, titleContenerView)
        titleContenerView.addSubview(titleLabel)
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        setUpConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        valueLabel.text = nil
        titleLabel.text = nil
        iconImageView.image = nil
        iconImageView.tintColor = .label
        titleLabel.tintColor = .label
    }
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleContenerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            titleContenerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            titleContenerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            titleContenerView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.33),
            
            titleLabel.leftAnchor.constraint(equalTo: titleContenerView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: titleContenerView.rightAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: titleContenerView.bottomAnchor),
            titleLabel.heightAnchor.constraint(equalTo: titleContenerView.heightAnchor),
            
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 35),
            
            valueLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor , constant: 10),
            valueLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: titleContenerView.topAnchor)
        ])
    }
    public func configure(wiht viewModel: RMCharacterInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        valueLabel.text = viewModel.displayValue
        iconImageView.image = viewModel.image
        iconImageView.tintColor = viewModel.tintColor
        titleLabel.tintColor = viewModel.tintColor
    }
}
