//
//  DataManager.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    
    static let shared = DataManager()

    @Published var allCategories: [SportsCategory] = []
    
    func setNewCategories(newCategories: [SportsCategoryDTO]) {
        
        var defaultPriorityIndex = 0
        
        allCategories = newCategories.map { dtoCategory in
            
            let allEventsFromDTOs = dtoCategory.e.map { eventTDO in
            
                defaultPriorityIndex += 1
                
                return SportsEvent(eventId: eventTDO.i,
                                   sportId: eventTDO.si,
                                   eventName: eventTDO.d,
                                   eventDate: Date.init(timeIntervalSince1970: eventTDO.tt),
                                   isFavourite: false,
                                   defaultPriorityIndex: defaultPriorityIndex)
            }
            
            return SportsCategory(sportId: dtoCategory.i,
                                  categoryName: dtoCategory.d,
                                  allEventsOfThisCategory: allEventsFromDTOs)
        }
        
        updateSortingOfAll()
        
    }
    
    func setThisEventFavourite(eventID: String, sportId: String) {
        
        if let indexCategory = allCategories.firstIndex(where: { $0.sportId == sportId }) {
            
            if let indexEvent = allCategories[indexCategory].allEventsOfThisCategory.firstIndex(where: { $0.eventId == eventID }) {
            
                let category = allCategories[indexCategory]
                let event = category.allEventsOfThisCategory[indexEvent]
                event.isFavourite.toggle()
                category.allEventsOfThisCategory[indexEvent] = event
                
                let newSortedEvents = updateSortingOfThisCategory(sportId: sportId)

                allCategories[indexCategory].allEventsOfThisCategory = newSortedEvents
                
            }
        }

    }
    
    func updateSortingOfThisCategory(sportId: String) -> [SportsEvent] {
        
        if let indexCategory = allCategories.firstIndex(where: { $0.sportId == sportId }) {
            
            let category = allCategories[indexCategory]
            
            // Create the priority logic based on Favourite boolean:
            var priorities = [String: Int]()
            
            for event in category.allEventsOfThisCategory {
                
                priorities[event.eventId] = event.isFavourite ? 1 : 0
                
            }
            
            // Sort the events based on the priority of the Favourite
            // and if same lets use the Date to show first the events that will start sooner !
            let sortedEventsOfThisCategory = category
                .allEventsOfThisCategory
                .sorted(by: { event1, event2 in
                    
                    if priorities.keys.contains(event1.eventId),
                       priorities.keys.contains(event2.eventId),
                       let priority1 = priorities[event1.eventId],
                       let priority2 = priorities[event2.eventId] {
                        
                        if priority1 == priority2 {
                            
                            if event1.eventDate == event2.eventDate {
                                
                                return event1.defaultPriorityIndex < event2.defaultPriorityIndex
                                
                            } else {
                                
                                return event1.eventDate < event2.eventDate
                                
                            }
                            
                        } else {
                            
                            return priority1 > priority2
                            
                        }
                        
                    } else {
                        
                        return false
                        
                    }
                    
                })
            
            return sortedEventsOfThisCategory
            
        }
        
        return [SportsEvent]()
    
    }
    
    func updateSortingOfAll() {

        for category in allCategories {
            
            let sortedEvents = updateSortingOfThisCategory(sportId: category.sportId)
            
            if let indexCategory = allCategories.firstIndex(where: { $0.sportId == category.sportId }) {

                allCategories[indexCategory].allEventsOfThisCategory = sortedEvents

            }
            
        }
                        
    }
    
    func getEventsOfThisCategory(sportsId: String) -> AnyPublisher<[SportsEvent], Never> {
                
        return $allCategories
            .flatMap { allCategories -> AnyPublisher<[SportsEvent], Never> in
                guard let category = allCategories.first(where: { $0.sportId == sportsId }) else {
                    return Just([SportsEvent]()).eraseToAnyPublisher()
                }
                return category.$allEventsOfThisCategory.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
        
    }
         
}
