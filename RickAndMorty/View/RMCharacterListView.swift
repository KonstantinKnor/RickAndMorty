//
//  CharacterListView.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 18.02.2023.
//

import UIKit

class RMCharacterListView: UIView {
    
    private let viewModel = RMCharacterListViewViewModel()
    private let spiner: UIActivityIndicatorView = {
        let spiner = UIActivityIndicatorView(style: .large)
        spiner.hidesWhenStopped = true
        spiner.translatesAutoresizingMaskIntoConstraints = false
        return spiner
    }()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alpha = 0
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        spiner.startAnimating()
        viewModel.delegate = self
        viewModel.fetchCharacter()
        setUpCollectionView()
        addSubviews(spiner, collectionView)
        addConstraints()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            spiner.widthAnchor.constraint(equalToConstant: 100),
            spiner.heightAnchor.constraint(equalToConstant: 100),
            spiner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spiner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    
    private func setUpCollectionView(){
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}
                                
extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    func didLoadInitialCharacters() {
        spiner.stopAnimating()
        collectionView.isHidden = false
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
}
