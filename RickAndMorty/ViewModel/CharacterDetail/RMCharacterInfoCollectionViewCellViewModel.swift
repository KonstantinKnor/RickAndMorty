//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 27.02.2023.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    private var type: `Type`
    private let value: String
    static let dateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formater.timeZone = .current
        return formater
    }()
    static let shortDateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.timeStyle = .short
        formater.timeZone = .current
        return formater
    }()
    public var title: String {
        type.displayTitel
    }
    public var image: UIImage? {
        type.iconImage
    }
    public var displayValue: String {
        if value.isEmpty { return "None" }
        if let date = Self.dateFormater.date(from: value), type == .created {
            return Self.shortDateFormater.string(from: date)
        }
        return value
    }
    public var tintColor: UIColor {
        return type.tintColor
    }
    enum `Type`: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount
        var tintColor: UIColor {
                switch self {
                case .status:
                    return .systemBlue
                case .gender:
                    return .systemRed
                case .type:
                    return .systemYellow
                case .species:
                    return .systemBrown
                case .origin:
                    return .systemGreen
                case .location:
                    return .systemPurple
                case .created:
                    return .systemMint
                case .episodeCount:
                    return .systemGray
                }
        }
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        var displayTitel: String {
            switch self {
            case .status,
                .gender,
                .type,
                .species,
                .origin,
                .created,
                .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "EPISODE COUNT"
            }
        }
    }

    
    init(type: `Type`,value: String) {
        self.value = value
        self.type = type
    }
}
