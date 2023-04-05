//
//  RMSettingsOptions.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 27.03.2023.
//

import Foundation
import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    var targetURL: URL? {
        switch self {
        case .rateApp:
            return nil
        case .contactUs:
            return URL(string: "https://iosacademy.io")
        case .terms:
            return URL(string: "https://iosacademy.io/terms")
        case .privacy:
            return URL(string: "https://iosacademy.io/privacy ")
        case .apiReference:
            return URL(string: "https://rickandmortyapi.com/documentation/#introduction")
        case .viewSeries:
            return URL(string: "https://www.youtube.com/playlist?list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4yn")
        case .viewCode:
            return URL(string: "https://github.com/KonstantinKnor/RickAndMorty")
        }
    }
    var displayTitel: String {
        switch self {
        case .rateApp:
            return "Rate App"
        case .contactUs:
            return "Contact us"
        case .terms:
            return "Term of sevice"
        case .privacy:
            return "Privacy police"
        case .apiReference:
            return "API reference"
        case .viewSeries:
            return "View video series"
        case .viewCode:
            return "View app code"
        }
    }
    var iconContainerColor: UIColor? {
        switch self {
        case .rateApp:
            return .systemMint
        case .contactUs:
            return .systemBlue
        case .terms:
            return .systemOrange
        case .privacy:
            return .systemPurple
        case .apiReference:
            return .systemYellow
        case .viewSeries:
            return .systemGreen
        case .viewCode:
            return .systemRed
        }
    }
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.bullet.rectangle.portrait")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
            }
        }
    }

