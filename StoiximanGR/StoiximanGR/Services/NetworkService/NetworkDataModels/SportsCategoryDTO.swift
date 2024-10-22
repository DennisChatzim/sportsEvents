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
    
    // Encoding
     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(i, forKey: .i)
         try container.encode(d, forKey: .d)
         try container.encode(e, forKey: .e)
     }

     // Decoding
    init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.i = try container.decode(String.self, forKey: .i)
         self.d = try container.decode(String.self, forKey: .d)
         self.e = try container.decode([SportsEventDTO].self, forKey: .e)
     }
    
    enum CodingKeys: String, CodingKey {
        case i = "i"
        case d = "d"
        case e = "e"
    }
}
