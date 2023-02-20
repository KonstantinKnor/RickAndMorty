//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 26.01.2023.
//

import UIKit
///Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    private var characterListView = RMCharacterListView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Character"
        setUpView()
    }
    private func setUpView(){
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
