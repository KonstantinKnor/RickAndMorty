//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 28.01.2023.
//

import Foundation

/// Represents unique API endpoint
@frozen enum RMEndpoint: String, CaseIterable, Hashable {
    /// Endpoint to get charater info
    case character
    /// Endpoint to get location info
    case location
    /// Endpoint to get episode info
    case episode
}
