//
//  TestSportsViewDetailsModel.swift
//  StoiximanGRTests
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//

import XCTest
import Combine


class SportsViewDetailsModelTests: XCTestCase {
    
    var model: SportsViewDetailsModel!
    var dataManager: DataManager!
    var sportsEvent: SportsEvent!

    override func setUpWithError() throws {
        
        // Create a mock DataManager
        // Initialize the DataManager and sportsEvent for testing
        dataManager = DataManager.shared

        sportsEvent = SportsEvent(eventId: "event1", sportId: "sport1", eventName: "Match 1", eventDate: Date(), isFavourite: false, defaultPriorityIndex: 0)
                
        // Initialize the model with the mock sports event
        model = SportsViewDetailsModel(sportsEvent: sportsEvent, dataManager: dataManager)
    }
    
    override func tearDownWithError() throws {
        // Clean up
        model = nil
        sportsEvent = nil
        dataManager = nil
    }

    func testInitialization() throws {
        // Verify the model initializes correctly
        XCTAssertEqual(model.sportsEvent.eventId, sportsEvent.eventId)
        XCTAssertEqual(model.sportsEvent.sportId, sportsEvent.sportId)
        XCTAssertFalse(model.isFavourite, "isFavourite should be false initially.")
    }
    
    func testUpdateFavourite() throws {
        // Set the sports event to be favourite
        sportsEvent.isFavourite = true
        
        // Update the favourite status
        model.updateFavourite()
                
        // Check if isFavourite is updated correctly
        XCTAssertTrue(model.isFavourite, "isFavourite should be updated to true.")
    }
}

