//
//  NetworkManager.swift
//  MarketFlow
//
//  Created by İrem Onart on 14.01.2025.
//

import Foundation

protocol NetworkManagerProtocol {
    func request<T: Decodable>(_ url: URL, method: String, body: Data?, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    // MARK: - Generic network request
    func request<T: Decodable>(_ url: URL, method: String = "GET", body: Data? = nil, completion: @escaping (Result<T, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NetworkError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    // MARK: - GET request
    func get<T: Decodable>(_ url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        request(url, method: "GET", completion: completion)
    }
    
}
