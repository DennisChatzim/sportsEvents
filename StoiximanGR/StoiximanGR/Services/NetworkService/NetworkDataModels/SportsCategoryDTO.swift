//
//  SportsCategoryDTO.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation

// Data Transfer Object: Here we define the expecting object as it comes from server !
struct SportsCategoryDTO: Codable, Hashable, Equatable {

    let i: String           // sport id -> Example: "FOOT"
    let d: String           // sport name -> Example: "SOCCER"
    let e: [SportsEventDTO] // Active events

    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(d)
    }
    
    static func == (lhs: SportsCategoryDTO, rhs: SportsCategoryDTO) -> Bool {
        return lhs.i == rhs.i
    }
        
    enum CodingKeys: String, CodingKey {
        case i = "i"
        case d = "d"
        case e = "e"
    }
}
