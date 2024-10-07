//
//  SportsViewDetails.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import SwiftUI


struct SportsViewDetails: View {
    
    @Environment(\.router) var navRouter
    @ObservedObject var model: SportsViewDetailsModel
    @ObservedObject var themeService: ThemeService

    var body: some View {
        
        ZStack {
            VStack(alignment: .center) {
                
                HStack {
                    Image(systemName: model.isFavourite ? "star.fill" : "star")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .background(Color.clear)
                        .foregroundColor(model.isFavourite ? themeService.selectedTheme.favouriteActiveColour : themeService.selectedTheme.favouriteInactiveColour)
                        .bounceTap(withBorder: true,
                                   extraBounce: true,
                                   pressedBGColor: Color.clear,
                                   theme: themeService.selectedTheme,
                                   action: {
                            model.updateFavourite()
                        })
                }
                .padding()
                
                VStack(alignment: .center, spacing: 16) {
                    
                    Text(model.sportsEvent.eventName)
                        .font(Font.system(size: 25, weight: .medium))
                        .lineLimit(1)
                    
                    Text(model.sportsEvent.eventDescription)
                        .font(.footnote)
                        .lineLimit(20)
                    
                }
                .padding()
                
                Spacer()
                
            }
            .padding()
        }
        .background(themeService.selectedTheme.mainBGColor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(model.sportsEvent.eventName)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButtonView {
            navRouter.navigateBack()
        })
        
    }
}

#Preview {
    SportsViewDetails(model: SportsViewDetailsModel(sportsEvent: SportsEvent(eventId: "eventId",
                                                                             sportId: "sportId",
                                                                             eventName: "Event name",
                                                                             eventDate: Date(),
                                                                             isFavourite: false,
                                                                             defaultPriorityIndex: 0),
                                                    dataManager: DataManager.shared),
                      themeService: ThemeService.shared)
}
