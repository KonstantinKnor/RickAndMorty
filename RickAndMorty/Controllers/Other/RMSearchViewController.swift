//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 22.03.2023.
//

import UIKit

/// Configurable controller to search
final class RMSearchViewController: UIViewController {

    struct Config {
        enum `Type` {
            case caracter
            case location
            case episode
            
            var title: String {
                switch self {
                case .caracter:
                    return "Search caracters"
                case .location:
                    return "Search locations"
                case .episode:
                    return "Search episode"
                }
            }
        }
        
        let type: `Type`
         
    }
    private let config: Config
    
    // MARK: - init
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = config.type.title 
        view.backgroundColor = .systemBackground
    }
    

}
