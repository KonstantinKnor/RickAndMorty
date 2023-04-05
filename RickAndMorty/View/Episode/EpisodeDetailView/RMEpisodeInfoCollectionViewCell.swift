//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 24.03.2023.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "RMEpisodeInfoCollectionViewCellViewModel"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        addSubviews(titleLabel, valueLabel)
        addConstraints()
        setUpLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
         
    }
    
    override func prepareForReuse() {
        titleLabel.text = nil
        valueLabel.text = nil
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            valueLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            valueLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.47),
            valueLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.47)
        ])
    }
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.masksToBounds = true
    }
    
    public func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel) {
        titleLabel.text = viewModel.titel
        valueLabel.text = viewModel.value
    }
}
