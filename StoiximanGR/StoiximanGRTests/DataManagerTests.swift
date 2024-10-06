//
//  DataManagerTests.swift
//  StoiximanGRTests
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//

import XCTest

import XCTest
import Combine

class DataManagerTests: XCTestCase {
    
    var dataManager: DataManager!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        dataManager = DataManager.shared
        cancellables = []
    }

    override func tearDown() {
        dataManager = nil
        cancellables = nil
        super.tearDown()
    }

    func testSetNewCategories() {
        let categoryDTO = SportsCategoryDTO(i: "1", d: "Soccer", e: [
            SportsEventDTO(i: "e1", si: "1", d: "Match 1", tt: 1700000000),
            SportsEventDTO(i: "e2", si: "1", d: "Match 2", tt: 1700003600)
        ])
        
        dataManager.setNewCategories(newCategories: [categoryDTO])
        
        XCTAssertEqual(dataManager.allCategories.count, 1)
        XCTAssertEqual(dataManager.allCategories[0].categoryName, "Soccer")
        XCTAssertEqual(dataManager.allCategories[0].allEventsOfThisCategory.count, 2)
        XCTAssertEqual(dataManager.allCategories[0].allEventsOfThisCategory[0].eventName, "Match 1")
    }

    func testSetThisEventFavourite() {
        let categoryDTO = SportsCategoryDTO(i: "1", d: "Soccer", e: [
            SportsEventDTO(i: "e1", si: "1", d: "Match 1", tt: 1700000000)
        ])
        
        dataManager.setNewCategories(newCategories: [categoryDTO])
        dataManager.setThisEventFavourite(eventID: "e1", sportId: "1")
        
        let event = dataManager.allCategories[0].allEventsOfThisCategory[0]
        XCTAssertTrue(event.isFavourite)
    }

    func updateSortingOfAll() {
        let categoryDTO = SportsCategoryDTO(i: "1", d: "Soccer", e: [
            SportsEventDTO(i: "e1", si: "1", d: "Match 1", tt: 1700000000),
            SportsEventDTO(i: "e2", si: "1", d: "Match 2", tt: 1700003600)
        ])
        
        dataManager.setNewCategories(newCategories: [categoryDTO])
        dataManager.setThisEventFavourite(eventID: "e1", sportId: "1") // Make event e1 favourite

        // This call is necessary to trigger sorting after making an event favourite
        dataManager.updateSortingOfAll()

        XCTAssertTrue(dataManager.allCategories[0].allEventsOfThisCategory[0].isFavourite) // e1 should be first
        XCTAssertEqual(dataManager.allCategories[0].allEventsOfThisCategory[0].eventId, "e1")
    }

    func testGetEventsOfThisCategory() {
        let categoryDTO = SportsCategoryDTO(i: "1", d: "Soccer", e: [
            SportsEventDTO(i: "e1", si: "1", d: "Match 1", tt: 1700000000)
        ])
        
        let expectation = self.expectation(description: "Fetch Events")
        
        dataManager.setNewCategories(newCategories: [categoryDTO])
        
        dataManager.getEventsOfThisCategory(sportsId: "1")
            .sink(receiveValue: { events in
                XCTAssertEqual(events.count, 1)
                XCTAssertEqual(events[0].eventId, "e1")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
