//
//  RMService.swift
//  RickAndMorty
//
//  Created by Константин Кнор on 28.01.2023.
//

import Foundation

///Primary API service object to get Rick and Morty data
final class RMService {
    ///Shared singleton instance
    static let shared = RMService()
    
    ///Privatized constructor
    private init() {}
    
    enum RMServiceError: Error {
        case failedToCreatedRequest
        case failedToGetData
    }
    /// Send Rick and Morty API Call
    /// - Parameters:
    /// - request: Request instance
    /// - type: The type of object we expect to get back 
    /// - completion: Callback with data and error
    public func execute<T: Codable>(_ request: RMRequest,
                                    expecting type: T.Type,
                                    completion: @escaping (Result<T, Error>) -> Void) {
        guard let request = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreatedRequest))
            return }
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(RMServiceError.failedToGetData))
                return
            }
            do{
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch{
                completion(.failure(error))
            }
            
        }
        task.resume()
    }
    
    // MARC: - Private
    
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else { return nil}
        var request = URLRequest(url: url )
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}
