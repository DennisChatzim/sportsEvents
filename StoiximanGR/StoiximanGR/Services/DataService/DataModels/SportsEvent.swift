//
//  SportsEventModel.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation

class SportsEvent: Codable, Identifiable, Equatable, Hashable, ObservableObject {
    
    let eventId: String    // event id -> Example: "22911144"
    let sportId: String    // sport id -> Example: "FOOT"
    let eventName: String  // Event name -> Example: Greece-Spain
    let eventDate: Date    // Event start time timestamp -> Example: 1657944684
    @Published var isFavourite = false
    var defaultPriorityIndex: Int = 0
    
    static func == (lhs: SportsEvent, rhs: SportsEvent) -> Bool {
        return lhs.eventId == rhs.eventId && lhs.sportId == rhs.sportId
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(eventId)
        hasher.combine(sportId)
    }
    
    init(eventId: String,
         sportId: String,
         eventName: String,
         eventDate: Date,
         isFavourite: Bool = false,
         defaultPriorityIndex: Int) {
        
        self.eventId = eventId
        self.sportId = sportId
        self.eventName = eventName
        self.eventDate = eventDate
        self.isFavourite = isFavourite
        self.defaultPriorityIndex = defaultPriorityIndex
        
    }
    
    var eventDescription: String {
        return eventName + "\nThis event will start on \(eventDateReadable)\n\(currentRemainingTime(currentDate: Date()))" // TODO: Use Localization
    }
    
    func currentRemainingTime(currentDate: Date) -> String {
        return "\nRemaining time: \(self.timeRemainingInDaysHoursMinutesSeconds(currentDate: Date()))" // TODO: Use Localization
    }
    
    var eventDateReadable: String {
        return eventDateFormatter.string(from: eventDate)
    }
   
    // Ok so updating so many data Events = Views every second is not good idea
    // The reason that I kept it 2 second accuracy is that on real devices I didn't notice any performance issues, on simulator it has some minor scrolling gaps
    // I would suggest to change the format that requirements defined: "00:00:00" and keep the remaining time max accuracy to minutes instead of seconds !
    // We could then set this variable to 30 seconds (realtimeSecondsToUpdateRemainingTime) to improve a lot the scrolling performance and
    // Also we should change the format of remaining time to show always "DD:HH:MM" = Days-Hour-Minutes -> example: "1d:22h:46m"
    // I did this already for the events that will start in more than 1 day -> format will be: "1d:22h:46m"
    func timeRemainingInDaysHoursMinutesSeconds(currentDate: Date) -> String {
        
        let timeInterval = eventDate.timeIntervalSince(currentDate) // Get the difference in seconds
        
        if timeInterval > 0 {
            
            let totalHours = Int(timeInterval) / 3600
            let days = totalHours / 24
            let hours = totalHours % 24
            let minutes = (Int(timeInterval) % 3600) / 60
            let seconds = Int(timeInterval) % 60
            
            // Format to ensure two digits for hours, minutes, and seconds
            let formattedHours = String(format: "%02d", hours)
            let formattedMinutes = String(format: "%02d", minutes)
            let formattedSeconds = String(format: "%02d", seconds)
            
            // If the total hours are 24 or more, include days in the output
            if totalHours >= 24 {
                return "\(days)d:\(formattedHours)h:\(formattedMinutes)m"
            } else {
                return "\(formattedHours):\(formattedMinutes):\(formattedSeconds)"
            }
            
        } else {
            return "Date Passed" // Here we could show other text like "Event started or finished"
        }
    }
    
    // Date Formatter for timestamp
    private let eventDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .full
        return formatter
    }()

    // Encoding
     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(eventId, forKey: .eventId)
         try container.encode(sportId, forKey: .sportId)
         try container.encode(eventName, forKey: .eventName)
         try container.encode(eventDate, forKey: .eventDate)
         try container.encode(isFavourite, forKey: .isFavourite)
     }

     // Decoding
     required init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         self.eventId = try container.decode(String.self, forKey: .eventId)
         self.sportId = try container.decode(String.self, forKey: .sportId)
         self.eventName = try container.decode(String.self, forKey: .eventName)
         self.eventDate = try container.decode(Date.self, forKey: .eventDate)
         self.isFavourite = try container.decodeIfPresent(Bool.self, forKey: .isFavourite) ?? false
     }

     // Coding Keys
     enum CodingKeys: String, CodingKey {
         case eventId
         case sportId
         case eventName
         case eventDate
         case isFavourite
     }
     
}
