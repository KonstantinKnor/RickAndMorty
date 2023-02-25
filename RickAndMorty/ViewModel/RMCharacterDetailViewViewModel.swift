//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 22.02.2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    init (character: RMCharacter){
        self.character = character
    }
    public var requestUrl: URL? {
        return URL(string: character.url)
    }
    public var title: String {
        character.name.uppercased()
    }
    
}
