//
//  NavigationRouter.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import SwiftUI

final class RouterNav: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case eventDetails(sportsEvent: SportsEvent)
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        guard navPath.count > 0 else { return }
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
    
    func destinationView(viewDestination: Destination) -> some View {
        switch viewDestination {
        case .eventDetails(let sportsEvent):
            
            return SportsViewDetails(model: SportsViewDetailsModel(sportsEvent: sportsEvent))
            
        }
    }
}
