//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 27.03.2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    
    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void 
    
    //MARK: - Init
    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    //MARK: - Public
    public let id = UUID()
    
    public var image: UIImage?{
        return type.iconImage
    }
    public var titel: String{
        return type.displayTitel
    }
    public var iconContainerColor: UIColor? {
        return type.iconContainerColor
    }
}
