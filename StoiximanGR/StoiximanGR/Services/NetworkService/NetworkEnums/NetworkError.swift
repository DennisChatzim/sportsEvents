//
//  NetworkError.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    
    case badURL
    case requestFailed
    case notConnected
    case invalidResponse
    case decodingError
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return LocalizedString.urlIsInvalid
        case .requestFailed:
            return LocalizedString.networkRequestfailedGeneral
        case .notConnected:
            return LocalizedString.notConnectedMessage
        case .invalidResponse:
            return LocalizedString.serverResponseNotValid
        case .decodingError:
            return LocalizedString.decodingErrorMessage
      case .serverError(let statusCode):
            return LocalizedString.serverStatusCodeError + "\(statusCode)"
        }
    }
}
