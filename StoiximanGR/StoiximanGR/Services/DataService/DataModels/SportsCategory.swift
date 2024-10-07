//
//  SportsCategory.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//
import SwiftUI

class SportsCategory: Hashable, Equatable, ObservableObject {

    let sportId: String         // sport id -> Example: "FOOT"
    let categoryName: String    // sport name -> Example: "SOCCER"
    @Published var allEventsOfThisCategory: [SportsEvent]  // All events

    func hash(into hasher: inout Hasher) {
        hasher.combine(sportId)
        hasher.combine(categoryName)
    }
    
    static func == (lhs: SportsCategory, rhs: SportsCategory) -> Bool {
        return lhs.sportId == rhs.sportId
    }
    
    init(sportId: String,
         categoryName: String,
         allEventsOfThisCategory: [SportsEvent]) {
        
        self.sportId = sportId
        self.categoryName = categoryName
        self.allEventsOfThisCategory = allEventsOfThisCategory
        
    }
    
    // MARK: Normally these icons should come as url from backend inside each sport category, not hardoded here locally :(
    static func getIconNameFor(sportId: String) -> String {

        switch sportId {
        case "FOOT":
            return "footBall"
        case "BASK":
            return "basketBallBall"
        case "TENN":
            return "tennisBall"
        case "VOLL":
            return "voley"
        case "DART":
            return "dart-board"
        case "TABL":
            return "tableTennis"
        case "ESPS":
            return "sportsGeneral"
        case "ICEH":
            return "hockeyIcon"
        case "SNOO":
            return "snookerIcon"
        case "HAND":
            return "handBall"
        default:
            return "sportsGeneral"
        }
    }
    
}
