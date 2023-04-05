//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 27.02.2023.
//

import Foundation
import UIKit

protocol RMEpisodeDataRender { //для паттерна (также подписываем модель RMEpisode на данные протокол)
    var name: String { get }
    var air_date: String { get }
    var episode: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel {
    
    private let episodeDataUrl: URL?
    private var isFetching = false
    public var borderColor: UIColor
    private  var dataBlock: ((RMEpisodeDataRender) -> Void)?// pattern
    private var episode: RMEpisode? { // передаем данные на RMCharacterEpisodeCollectionViewCell с помощью патерна подписчик
        didSet {
            guard let model = episode else {
                return
            }
            dataBlock?(model)
        }
    }
    
    
    //MARK: - Init
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue){
        self.borderColor = borderColor
        self.episodeDataUrl = episodeDataUrl
    }
    //MARK: - Public
    
    public func registerForData(_ block: @escaping(RMEpisodeDataRender) -> Void){// паттерн
        self.dataBlock = block
    }
    
    public func fetchEpisode(){
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let episodeDataUrl = episodeDataUrl, let request = RMRequest(url: episodeDataUrl) else {
            return
        }
        isFetching = true
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(_):
                print("Failed to get episode")
            }
        }
    }
}
