//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 21.03.2023.
//

import UIKit

protocol RMEpisodeDetailViewDeledate: AnyObject {
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, character: RMCharacter)
}

final class RMEpisodeDetailView: UIView {
    
    public weak var delegate: RMEpisodeDetailViewDeledate?
    private var viewModel: RMEpisodeDetailViewViewModel?{
        didSet {
            spiner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.collectionView?.alpha = 1
            })
        }
    }
    
    private var collectionView: UICollectionView?
    private let spiner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView()
        spiner.translatesAutoresizingMaskIntoConstraints = false
        spiner.hidesWhenStopped = true
        return spiner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        addSubviews(collectionView, spiner)
        self.collectionView = collectionView
        spiner.startAnimating()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(RMEpisodeInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.identifier)
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else {
            return
        }

        NSLayoutConstraint.activate([
            spiner.heightAnchor.constraint(equalToConstant: 100),
            spiner.widthAnchor.constraint(equalToConstant: 100),
            spiner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spiner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    public func configure(with viewModel: RMEpisodeDetailViewViewModel) {
        self.viewModel = viewModel
    }
}
// MARK: - CollectionViewDelegate
extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionType = viewModel?.cellViewModels[section] else { return 0 }
        switch sectionType {
        case .information(viewModel: let viewModel):
            return viewModel.count
        case .characters(viewModel: let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sectionType = viewModel?.cellViewModels[indexPath.section] else {
            fatalError("No viewModel ")
        }
        switch sectionType {
        case .information(viewModel: let viewModel):
            let cellViewModel = viewModel[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeInfoCollectionViewCell.identifier, for: indexPath) as? RMEpisodeInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        case .characters(viewModel: let viewModel):
            let cellViewModel = viewModel[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let sectionType = viewModel?.cellViewModels[indexPath.section] else {
            fatalError("No viewModel ")
        }
        switch sectionType {
            case .information:
                break
            case .characters:
            guard let character = viewModel?.character(at: indexPath.row) else { return }
            delegate?.rmEpisodeDetailView(self, character: character)
        }
        
    }
    
}

extension RMEpisodeDetailView {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }
        switch sections[section] {
        case .information:
           return createInfoLayout()
        case .characters:
          return createCharacterLayout()
        }
    }
    
    private func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1))
                )
                item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                             leading: 10,
                                                             bottom: 10,
                                                             trailing: 10)
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                ),
                    subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
    }
    private func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0))
        )
        item.contentInsets = NSDirectionalEdgeInsets(top: 7,
                                                     leading: 10,
                                                     bottom: 7,
                                                     trailing: 10)
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(260)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

