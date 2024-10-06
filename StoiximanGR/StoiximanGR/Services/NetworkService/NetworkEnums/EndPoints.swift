//
//  EndPoints.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Network
import Foundation

enum APIEndpoint {
    
    static let baseURL = "https://ios-kaizen.github.io"
    
    case sportsEventsList
    case sportEventDetails
    
    var path: String {
        switch self {
        case .sportsEventsList:
            return "/MockSports/sports.json"
        case .sportEventDetails:
            return "/MockSports/some_path_for_details_of_the_event"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .sportsEventsList:
            return HTTPMethod.GET
        case .sportEventDetails:
            return HTTPMethod.GET
        }
    }
    
    var url: URL? {
        return URL(string: APIEndpoint.baseURL + path)
    }
}

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}
