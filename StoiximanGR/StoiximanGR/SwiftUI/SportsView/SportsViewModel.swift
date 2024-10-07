//
//  SportsViewModel.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation
import SwiftUI

class SportsViewModel: ObservableObject {
    
    @Published var allCategories: [SportsCategory] = []
    @Published var isLoading = true // We start with true because we need to make sure that Loaders are shown imediately when application starts until we get the first data !
    @Published var errorMessage: String? = nil
    @Published var showAlert = false
    @Published var collapsedCategories: [SportsCategory] = []
    @Published var dataManager: DataManager
    @Published var networkManager: NetworkManagerProtocol
    
    init(dataManager: DataManager,
         networkManager: NetworkManagerProtocol) {
        
        self.dataManager = dataManager
        self.networkManager = networkManager
        
        let newCategoriesArrived = self.dataManager.$allCategories

        newCategoriesArrived
            .dropFirst()
            .receive(on: DispatchQueue.main) // This will ensure that sink will occur on main thread !
            .assign(to: &$allCategories)
        
        newCategoriesArrived
            .map { _ in return false }
            .receive(on: DispatchQueue.main) // This will ensure that sink will occur on main thread !
            .assign(to: &$isLoading)

    }
        
    func loadData() async {
        
        do {
            try await networkManager.fetchSportsEvents()
            DispatchQueue.main.async {  self.isLoading = false } // Lets make sure spinners are dismissed additionally here
        } catch {
            DispatchQueue.main.async { // we need this in order to keep the http can in background thread and the result handling in Main thred -> Update UI
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showAlert = true
            }
        }
        
    }
    
    func toggleCategoryVisibility(_ category: SportsCategory) {
        if let index = collapsedCategories.firstIndex(where: { $0.sportId == category.sportId }) {
            collapsedCategories.remove(at: index)
        } else {
            collapsedCategories.append(category)
        }
    }
    
    func isCategoryCollapsed(category: SportsCategory) -> Bool {
        return collapsedCategories.contains(where: { $0.sportId == category.sportId })
    }
    
}
