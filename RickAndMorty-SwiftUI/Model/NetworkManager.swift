//
//  NetworkManager.swift
//  RickAndMorty-SwiftUI
//
//  Created by Ana Ptskialadze on 13.06.24.
//

import Foundation

class NetworkManager: ObservableObject {
    
    static let shared = NetworkManager()
    
    enum APIError: Error {
        case invalidURL
        case requestFailed
    }
    
    //    enum Endpoint: String {
    //        case characters = "/api/character"
    //        case locations = "/api/location"
    //        case episodes = "/api/episode"
    //    }
    
    enum Endpoint {
        case characters
        case locations
        case episodes
        case custom(url: URL)
    }
    
    //    func fetchData<T: Decodable>(from endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
    //        var componentURL = URLComponents()
    //        componentURL.scheme = "https"
    //        componentURL.host = "rickandmortyapi.com"
    //        componentURL.path = endpoint.rawValue
    //
    //        guard let validURL = componentURL.url else {
    //            completion(.failure(APIError.invalidURL))
    //            return
    //        }
    
    func fetchData<T: Decodable>(from endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
        let url: URL
        switch endpoint {
        case .characters:
            url = URL(string: "https://rickandmortyapi.com/api/character")!
        case .locations:
            url = URL(string: "https://rickandmortyapi.com/api/location")!
        case .episodes:
            url = URL(string: "https://rickandmortyapi.com/api/episode")!
        case .custom(let customURL):
            url = customURL
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.requestFailed))
                }
                return
            }
            do {
                let results = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
