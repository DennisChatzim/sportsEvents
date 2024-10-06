//
//  TestSportsViewModel.swift
//  StoiximanGRTests
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//

import XCTest
import Combine
//@testable import StoiximanGR

final class SportsViewModelTests: XCTestCase {
    
    var viewModel: SportsViewModel!
    var mockDataManager: DataManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockDataManager = DataManager.shared //MockDataManager()
        let mockNetworkManager = MockNetworkManager(success: true, error: nil)
        viewModel = SportsViewModel(dataManager: mockDataManager, networkManager: mockNetworkManager)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockDataManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialization_withCategoriesFromDataManager() async {
        
        // Given
        let mockNetworkManager = MockNetworkManager(success: true, error: nil)

        let categories = [SportsCategory(sportId: "1", categoryName: "Football", allEventsOfThisCategory: [])]
        // mockDataManager.allCategories = categories
        
        viewModel = SportsViewModel(dataManager: mockDataManager, networkManager: mockNetworkManager)

        // When
        let expectation = XCTestExpectation(description: "Categories updated")
             
        viewModel.$allCategories
            .dropFirst()
            .sink { updatedCategories in
                // Then
                XCTAssertEqual(updatedCategories, categories)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        // Making HTTP call and updating data:
        await viewModel.loadData()
        
        XCTAssertNil(viewModel.errorMessage)

        mockDataManager.allCategories = categories

        await fulfillment(of: [expectation], timeout: 2.0, enforceOrder: false)
    }
    
    func testLoadData_withSuccess() async {
        
        // Given
        let mockNetworkManager = MockNetworkManager(success: true)
        viewModel.networkManager = mockNetworkManager
        
        // When
        await viewModel.loadData()
        
        // Then
        // Simulate the async operation in another thread
        Task {
            // Simulate a delay before the condition is expected to change
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 2 seconds

            // Then
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.showAlert)
            
        }
        
    }
    
    func testLoadData_withFailure() async {
        
        // Given
        let mockNetworkManager =  MockNetworkManager(success: false, error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network Error"]))

        let categories = [SportsCategory(sportId: "1", categoryName: "Football", allEventsOfThisCategory: [])]
        mockDataManager.allCategories = categories
        
        viewModel = SportsViewModel(dataManager: mockDataManager, networkManager: mockNetworkManager)

        // When
        await viewModel.loadData()
                
        // Simulate the async operation in another thread
        Task {
            // Simulate a delay before the condition is expected to change
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 2 seconds

            // Then
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertEqual(viewModel.errorMessage, "Network Error")
            XCTAssertTrue(viewModel.showAlert)
            
        }
        
    }
    
    func testToggleCategoryVisibility() {
        
        // Given
        let category = SportsCategory(sportId: "1", categoryName: "Football", allEventsOfThisCategory: [])
        
        // When - Toggle to collapse
        viewModel.toggleCategoryVisibility(category)
        
        // Then
        XCTAssertTrue(viewModel.isCollapsed(category: category))
        
        // When - Toggle to expand
        viewModel.toggleCategoryVisibility(category)
        
        // Then
        XCTAssertFalse(viewModel.isCollapsed(category: category))
    }
    
    func testIsCollapsed() {
        
        // Given
        let category = SportsCategory(sportId: "1", categoryName: "Football", allEventsOfThisCategory: [])
        
        // When the category is not collapsed
        XCTAssertFalse(viewModel.isCollapsed(category: category))
        
        // When the category is collapsed
        viewModel.collapsedCategories.append(category)
        XCTAssertTrue(viewModel.isCollapsed(category: category))
    }
}
