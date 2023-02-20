//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 26.01.2023.
//

import UIKit

/// Controller to house tabs and root tab controllers 
final class RMTabBarViewController: UITabBarController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUPTab()
    }
    private func setUPTab(){
        let characterVC = RMCharacterViewController()
        let locationVC = RMLocationViewController()
        let episodeVC = RMEpisodeViewController()
        let settingsVC = RMSettingsViewController()
        
        let nav1 = UINavigationController(rootViewController: characterVC)
        let nav2 = UINavigationController(rootViewController: locationVC)
        let nav3 = UINavigationController(rootViewController: episodeVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Character",
                                       image: UIImage(systemName: "person"),
                                       tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Location",
                                       image: UIImage(systemName: "globe"),
                                       tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Episode",
                                       image: UIImage(systemName: "tv"),
                                       tag: 3)
        nav4.tabBarItem = UITabBarItem(title: "Settings",
                                       image: UIImage(systemName: "gear"),
                                       tag: 4)
        let arrayNavs = [nav1, nav2, nav3, nav4]
        arrayNavs.forEach({
            $0.navigationBar.prefersLargeTitles = true
        })
        setViewControllers(arrayNavs, animated: true)
    }

}

