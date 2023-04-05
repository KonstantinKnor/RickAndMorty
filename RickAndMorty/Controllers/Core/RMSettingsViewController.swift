//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 26.01.2023.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

///Controller to show various app options and settings
final class RMSettingsViewController: UIViewController {
    
//    private let viewModel = RMSettingsViewViewModel(cellViewModels: RMSettingsOption.allCases.compactMap({
//        return RMSettingsCellViewModel(type: $0) { option in
//            print(option.displayTitel)
//        }
//    }))
    private var settingsSwiffUIViewController: UIHostingController<RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
       addSwiffUIViewController()
    }
    
    private func addSwiffUIViewController() {
        let settingsSwiffUIViewController  = UIHostingController(rootView: RMSettingsView(viewModel: .init(cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0) { [weak self] option in
                self?.handleTap(option: option)
            }
        }))))
        addChild(settingsSwiffUIViewController)
        view.addSubviews(settingsSwiffUIViewController.view)
        settingsSwiffUIViewController.didMove(toParent: self)
        settingsSwiffUIViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsSwiffUIViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiffUIViewController.view.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiffUIViewController.view.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiffUIViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) 
        ])
        self.settingsSwiffUIViewController = settingsSwiffUIViewController
    }
    
    private func handleTap(option: RMSettingsOption){
        guard Thread.current.isMainThread else {
            return
        }
        if let url = option.targetURL {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            if let windowScene = view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windowScene)
            }
        }
    }
}
