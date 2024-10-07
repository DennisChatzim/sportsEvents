//
//  SportsViewDetailsModel.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//

import SwiftUI

class SportsViewDetailsModel: ObservableObject {
    
    @Published var dataManager: DataManager

    @Published var sportsEvent: SportsEvent

    @Published var isFavourite = false // We need this because SwiftUI doesn't update correctly when accessing variables of a Published variable of an observer object
    
    var disposeBag: DisposeBagForCombine = []

    init(sportsEvent: SportsEvent,
         dataManager: DataManager) {

        self.sportsEvent = sportsEvent
        self.dataManager = dataManager
        isFavourite = sportsEvent.isFavourite
    }
    
    func updateFavourite() {

        dataManager.setThisEventFavourite(eventID: sportsEvent.eventId,
                                          sportId: sportsEvent.sportId)
        
        isFavourite = sportsEvent.isFavourite
        
    }
        
}
