//
//  SportsEventDTO.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation

// Data Transfer Object
struct SportsEventDTO: Codable, Identifiable, Equatable, Hashable {

    let i: String  // event id -> Example: "22911144"
    let si: String // sport id -> Example: "FOOT"
    let d: String  // Event name -> Example: Greece-Spain
    let tt: TimeInterval    // Event start time timestamp -> Example: 1657944684
    var isFavourite = false
    
    static func == (lhs: SportsEventDTO, rhs: SportsEventDTO) -> Bool {
        return lhs.i == rhs.i && lhs.si == rhs.si
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(i)
        hasher.combine(si)
    }
    
    enum CodingKeys: String, CodingKey {
        case i = "i"
        case si = "si"
        case d = "d"
        case tt = "tt"
    }
    
    var id: String {
        return i
    }
    
}


