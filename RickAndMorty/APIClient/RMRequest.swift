//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 28.01.2023.
//

import Foundation

final class RMRequest {
    /// API Constants
    private struct Constants{
        static let baseURL = "https://rickandmortyapi.com/api"
    }
    /// Desired endpoint
    private let endpoint: Endpoint
    /// Path components for API, if any
    private let pathComponents: [String]
    ///Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    /// Constracted url for the API request in string format
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        if !pathComponents.isEmpty {
            pathComponents.forEach({string += "/\($0)"})
        }
        
        if !queryParameters.isEmpty{
            string += "?"
            let argumentString = queryParameters.compactMap({
               guard let value = $0.value else { return nil}
               return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        return string
    }
    /// Computed  & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    /// Desired http method
    public let httpMethod = "GET"
    init(endpoint: Endpoint,
         pathComponents: [String] = [],
         queryParameters: [URLQueryItem] = []
        ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}

extension RMRequest {
    static let listCharacterRequest = RMRequest(endpoint: .character)
}
