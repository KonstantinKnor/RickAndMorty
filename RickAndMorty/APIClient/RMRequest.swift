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
    private let endpoint: RMEndpoint
    /// Path components for API, if any
    private let pathComponents: [String]
    ///Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    ///
    private var page: String = ""
    /// Constracted url for the API request in string format
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue
        if page.contains("page"){
        string += "?\(page)"
        }
        if !pathComponents.isEmpty {
            pathComponents.forEach({string += "/\($0)"})
        }
        
        if !queryParameters.isEmpty{
            string += "?"
            let argumentString = queryParameters.compactMap({
               guard let value = $0.value else { return nil }
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
    public init(endpoint: RMEndpoint,
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []
            ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    /// Attempt to create request
    /// - Parameter url: URL to parse
    convenience init?(url: URL){ // не обязательный инициализатор, но должен содержать ссылку на обязавтельный
        let string = url.absoluteString //https://rickandmortyapi.com/api/character?page=2
        if !string.contains(Constants.baseURL){// проверяем содержит ли передаваемый url baseURL
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL + "/",
                                                  with: "") //character?page=2
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                var pathComponents: [String] = []
                let endpointString = components[0]
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    self.page = components[1]
                    return
                }
            }
        } else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?") //["character", "page=2"]
            if !components.isEmpty {
                let endpointString = components[0]//character
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){ //character
                    self.init(endpoint: rmEndpoint)
                    self.page = components[1]
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest {
    static let listCharacterRequest = RMRequest(endpoint: .character)
}
