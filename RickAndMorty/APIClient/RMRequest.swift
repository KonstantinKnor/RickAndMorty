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
    public init(endpoint: RMEndpoint,
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []
            ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
    
    convenience init?(url: URL){ // не обязательный инициализатор, но должен содержать ссылку на обязавтельный
        let string = url.absoluteString
        print(string)
        if !string.contains(Constants.baseURL){// проверяем содержит ли передаваемый url baseURL
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL + "/",
                                                  with: "")
        print(trimmed)
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            print(components)
            if !components.isEmpty {
                let endpointString = components[0]
                print(endpointString)
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    print(rmEndpoint)
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        } else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            print(components)
            if !components.isEmpty {
                let endpointString = components[0]
                print(endpointString)
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    print(rmEndpoint)
                    self.init(endpoint: rmEndpoint)
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
