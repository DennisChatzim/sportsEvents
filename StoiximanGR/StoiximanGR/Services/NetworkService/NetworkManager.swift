//
//  NetworkManager.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchSportsEvents() async throws
}

class NetworkManager: NetworkManagerProtocol {
  
    static let shared = NetworkManager()
    
    @Published var allCategories: [SportsCategoryDTO] = []

    func fetchSportsEvents() async throws {
        
        // Ensure the URL is valid
        guard let url = APIEndpoint.sportsEventsList.url else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = APIEndpoint.sportsEventsList.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData
        
        // Create a URLSession with custom timeout
        let urlconfig = URLSessionConfiguration.default
        urlconfig.timeoutIntervalForRequest = 15
        urlconfig.timeoutIntervalForResource = 20
        let session = URLSession(configuration: urlconfig)
        
        let (data, response) = try await session.data(for: request)
        
        // Check the HTTP response status
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
                
        do {
            let decodedResponse = try JSONDecoder().decode([SportsCategoryDTO].self, from: data)
            DispatchQueue.main.async {
                DataManager.shared.setNewCategories(newCategories: decodedResponse)
            }
        } catch DecodingError.dataCorrupted(let context) {
            debugPrint("Decoding error: \(context.debugDescription)")
            throw NetworkError.decodingError
        } catch DecodingError.keyNotFound(let key, let context) {
            debugPrint("Decoding error: \(key.stringValue) was not found, \(context.debugDescription)")
            throw NetworkError.decodingError
        } catch DecodingError.typeMismatch(let type, let context) {
            debugPrint("Decoding error: \(type) was expected, \(context.debugDescription)")
            throw NetworkError.decodingError
        } catch DecodingError.valueNotFound(let type, let context) {
            debugPrint("Decoding error: no value was found for \(type), \(context.debugDescription)")
            throw NetworkError.decodingError
        } catch {
            print("I know not this error")
            throw NetworkError.decodingError
        }
                
    }
    
}
