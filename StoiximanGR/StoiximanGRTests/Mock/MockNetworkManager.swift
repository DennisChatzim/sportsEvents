//
//  MockNetowrkManager.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//
@testable import StoiximanGR
import Combine
import Foundation

class MockNetworkManager: NetworkManagerProtocol {
      
    let success: Bool
    let error: Error?
    
    init(success: Bool, error: Error? = nil) {
        self.success = success
        self.error = error
    }
    
    func fetchSportsEvents() async throws {
        if success {
            // Simulate a successful fetch
        } else {
            throw error ?? NSError(domain: "", code: -1, userInfo: [:])
        }
    }
}
