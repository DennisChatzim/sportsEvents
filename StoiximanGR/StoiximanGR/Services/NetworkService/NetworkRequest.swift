//
//  NetworkLayer.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation
import Network
import Combine

typealias DisposeBagForCombine = Set<AnyCancellable>
extension DisposeBagForCombine {
    mutating func dispose() {
        forEach { $0.cancel() }
        removeAll()
    }
}


@globalActor
actor NetworkRequest {
    
    static let shared = NetworkRequest()
            
    static var isReachable: Bool = true
    
    var disposeBag: DisposeBagForCombine = []

    deinit {
        disposeBag.dispose()
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint, body: Data? = nil) async throws -> T {
        
        guard let url = endpoint.url else {
            throw NetworkError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
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

