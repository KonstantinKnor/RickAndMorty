//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 22.02.2023.
//

import UIKit

/// Controller to show info about single character
final class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel
    private let detailView: RMCharacterDetailView
    
    
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(didTapShare))
        addConstraints()
        self.detailView.collectionView?.delegate = self
        self.detailView.collectionView?.dataSource = self
    }
    
    @objc private func didTapShare(){
        
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {// delegate реализован через переменную collectionView в RMCharacterDetailView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case .information(let viewModel):
            return viewModel.count
        case .episodes(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo(let viewModel):
           guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier:  RMCharacterPhotoCollectionViewCell.cellIdentifer,
            for: indexPath) as? RMCharacterPhotoCollectionViewCell else {
               fatalError()
           }
            cell.configure(with: viewModel)
            return cell
        case .information(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
             withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifer,
             for: indexPath) as? RMCharacterInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(wiht: viewModel[indexPath.row])
             return cell
        case .episodes(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
             withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer,
             for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel[indexPath.row])
             return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case .photo, .information:
            break
        case .episodes:
            let episodes = self.viewModel.episods
            let sections = episodes[indexPath.row]
            let url = URL(string: sections)
            let vc = RMEpisodeDetailViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
