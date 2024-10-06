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
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showAlert = false

    @Published var collapsedCategories: [SportsCategory] = []
    var disposeBag: DisposeBagForCombine = []
    @Published var dataManager: DataManager
    @Published var networkManager: NetworkManagerProtocol

    init(dataManager: DataManager,
         networkManager: NetworkManagerProtocol) {
        
        self.dataManager = dataManager
        self.networkManager = networkManager
        reBindMainCategories()
      
    }
    
    func reBindMainCategories() {
        
        disposeBag.dispose()

        self.dataManager.$allCategories
            .dropFirst()
            .receive(on: DispatchQueue.main) // This will ensure that sink will occur on main thread !
            .sink(receiveValue: { [weak self] newCategories in
                self?.newCategoriesArrived(newCategories: newCategories)
            })
            .store(in: &disposeBag)
    }
    
    func newCategoriesArrived(newCategories: [SportsCategory]) {
                
        allCategories = newCategories
        isLoading = false // Lets make sure spinners are dismissed additionally here

    }

    func loadData() async {
        
        do {
            try await networkManager.fetchSportsEvents()
        } catch {
            DispatchQueue.main.async {
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
    
    func isCollapsed(category: SportsCategory) -> Bool {
        return collapsedCategories.contains(where: { $0.sportId == category.sportId })
    }
    
}
