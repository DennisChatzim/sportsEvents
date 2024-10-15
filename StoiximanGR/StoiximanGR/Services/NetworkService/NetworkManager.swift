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
    
    func fetchSportsEvents() async throws {
        
        do {
            let allCategories: [SportsCategoryDTO] = try await NetworkRequest.shared.request(.sportsEventsList)
            DispatchQueue.main.async {
                DataManager.shared.setNewCategories(newCategories: allCategories)
            }
        } catch {
            print("Error occured: \(error)")
            throw error
        }
        
    }
    
}
