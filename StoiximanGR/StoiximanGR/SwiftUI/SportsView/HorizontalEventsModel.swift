//
//  HorizontalEventsModel.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//
import Foundation
import Combine

class HorizontalEventsModel: ObservableObject {
    
    @Published var dataManager: DataManager

    @Published var events: [SportsEvent] = []

    init(sportId: String,
         dataManager: DataManager) {

        self.dataManager = dataManager
        
        self.dataManager
            .getEventsOfThisCategory(sportsId: sportId)
            .assign(to: &$events)
                        
    }
    
    func updateFavourite(eventId: String,
                         sportId: String) {
        
        dataManager.setThisEventFavourite(eventID: eventId,
                                          sportId: sportId)
        
    }
        
}
