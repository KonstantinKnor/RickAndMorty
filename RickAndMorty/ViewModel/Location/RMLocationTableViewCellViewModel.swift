//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 04.04.2023.
//

import Foundation

struct RMLocationTableViewCellViewModel: Hashable, Equatable {
    
    private let location: RMLocation
    
    init (location: RMLocation){
        self.location = location
    }
    
    public var name: String {
        location.name
    }
    public var type: String {
        "type: "+location.type
    }
    public var dimension: String {
        location.dimension
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.id)
    }
}
