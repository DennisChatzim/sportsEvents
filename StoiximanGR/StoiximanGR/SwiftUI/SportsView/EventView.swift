//
//  EventView.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 7/10/24.
//

import SwiftUI

struct EventView: View {
    
    @State var sportsEvent: SportsEvent
    @ObservedObject var timerManager: TimerManager
    @ObservedObject var dataManager: DataManager
    @State var theme: Theme
    var itemWidth: CGFloat
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Text(sportsEvent.timeRemainingInDaysHoursMinutesSeconds(currentDate: timerManager.currentDateSwiftUI))
                .font(Font.system(size: 14, weight: .regular))
                .lineLimit(1)
                .frame(width: itemWidth * 0.8) // We need to set explicitly the width to have consistent UI between all event cells-views
                .padding(.vertical, 6)
                .padding(.horizontal, 5)
                .overlay(RoundedRectangle(cornerRadius: 6)
                    .stroke(theme.customTextColour, lineWidth: 1)
                    .padding(1))

            Image(systemName: sportsEvent.isFavourite ? "star.fill" : "star")
                .resizable()
                .scaledToFit()
                .frame(width: 25)
                .background(Color.clear)
                .foregroundColor(sportsEvent.isFavourite ? theme.favouriteActiveColour : theme.favouriteInactiveColour)
                .padding(.vertical, 2)
                .bounceTap(withBorder: true,
                           extraBounce: true,
                           pressedBGColor: Color.clear,
                           theme: theme,
                           action: {
                    dataManager.setThisEventFavourite(eventID: sportsEvent.eventId,
                                                      sportId: sportsEvent.sportId)
                })
                        
            Text(sportsEvent.eventName)
                .font(Font.system(size: 13, weight: .regular))
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            Spacer()

        }
        .padding(.top, 10)
        .frame(width: itemWidth)
        
    }
}

