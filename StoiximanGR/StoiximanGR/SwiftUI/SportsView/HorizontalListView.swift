//
//  HorizontalListView.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import SwiftUI
import Combine

struct HorizontalListView: View {
    
    @ObservedObject var model: HorizontalEventsModel
    @ObservedObject var themeService: ThemeService
    @ObservedObject var timerManager = TimerManager.shared

    init(sportId: String,
         dataManager: DataManager,
         themeService: ThemeService,
         itemWidth: CGFloat,
         onEventTap: @escaping (SportsEvent) -> Void
    ) {
        
        model = HorizontalEventsModel(sportId: sportId, dataManager: dataManager)
        self.themeService = themeService
        self.itemWidth = itemWidth
        self.onEventTap = onEventTap
    }
    
    var itemWidth: CGFloat
    var onEventTap: (SportsEvent) -> Void
    
    var body: some View {
        
        ZStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                HStack(alignment: .top, spacing: 0) {

                    ForEach(model.events) { sportsEvent in

                        VStack(alignment: .center) {
                            
                            Text(sportsEvent.timeRemainingInDaysHoursMinutesSeconds(currentDate: timerManager.currentDate))
                                .font(Font.system(size: 14, weight: .regular))
                                .lineLimit(1)
                                .frame(width: itemWidth * 0.8) // We need to set explicitly the width to have consistent UI between all event cells-views
                                .padding(.vertical, 6)
                                .padding(.horizontal, 5)
                                .overlay(RoundedRectangle(cornerRadius: 6)
                                    .stroke(themeService.selectedTheme.customTextColour, lineWidth: 1)
                                    .padding(1))

                            Image(systemName: sportsEvent.isFavourite ? "star.fill" : "star")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                                .background(Color.clear)
                                .foregroundColor(sportsEvent.isFavourite ? themeService.selectedTheme.favouriteActiveColour : themeService.selectedTheme.favouriteInactiveColour)
                                .padding(.vertical, 2)
                                .onTapGesture {
                                    model.updateFavourite(eventId: sportsEvent.eventId,
                                                          sportId: sportsEvent.sportId)
                                }
                            
                            Text(sportsEvent.eventName)
                                .font(Font.system(size: 13, weight: .regular))
                                .multilineTextAlignment(.center)
                                .lineLimit(3)
                                .minimumScaleFactor(1.0)
                            
                        }
                        .frame(width: itemWidth)
                        .bounceTap(withBorder: true,
                                   extraBounce: false,
                                   pressedBGColor: Color.clear,
                                   action: {
                            onEventTap(sportsEvent)
                        })
                    }
                }
                .animation(Animation.linear(duration: 0.3), value: model.events)
                
            }
            .frame(height: 140)
            .padding(.vertical, 3)
            
        }
        .background(themeService.selectedTheme.mainBGColor)
        
    }
}


#Preview {
    HorizontalListView(sportId: "sportId",
                       dataManager: DataManager.shared,
                       themeService: ThemeService.shared,
                       itemWidth: 10.0,
                       onEventTap: { _ in })
}
