//
//  HorizontalListView.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import SwiftUI
import Combine

public func getEventCellWidth() -> CGFloat {
    let defaultWidth = UIScreen.main.bounds.size.width / 4.0
    let minWidth: CGFloat = 70.0
    let maxWidth: CGFloat = 150.0
    let filterMinWidth = max(defaultWidth, minWidth) // This will ensure that for very small screen sizes the width will never be LESS than 70.0
    return min(filterMinWidth, maxWidth)             // This will ensure that in LARGE screen such iPads the width will never be TOO LARGE, it will have max width = 150
}

struct HorizontalListView: View {
    
    @ObservedObject var model: HorizontalEventsModel
    @State var theme: Theme
    @ObservedObject var timerManager: TimerManager // Lets keep TimerManager in SwiftUI class instead of the model because it afffects the UI directly by its observer property currentDate

    init(sportId: String,
         dataManager: DataManager,
         timerManager: TimerManager,
         theme: Theme,
         itemWidth: CGFloat,
         onEventTap: @escaping (SportsEvent) -> Void
    ) {
        
        model = HorizontalEventsModel(sportId: sportId,
                                      dataManager: dataManager)
        self.timerManager = timerManager
        self.theme = theme
        self.itemWidth = itemWidth
        self.onEventTap = onEventTap
    }
    
    var itemWidth: CGFloat
    var onEventTap: (SportsEvent) -> Void
    
    var body: some View {
        
        ZStack {
            
            ScrollView(.horizontal, showsIndicators: false) {
                
               allEventsScrollView
                
            }
            .frame(height: 145)
            
        }
        .background(theme.mainBGColor)
        .animation(.easeInOut(duration: 0.5), value: theme)

    }
    
    @ViewBuilder // We use this for faster rendering and helping SwiftUI when the view contains multiple internal views !
    var allEventsScrollView: some View {
        
        HStack(alignment: .top, spacing: 0) {

            ForEach(model.events) { sportsEvent in

                createNewEventCellView(sportsEvent: sportsEvent)
                
            }
        }
        .animation(Animation.linear(duration: 0.3), value: model.events)
    }
    
    func createNewEventCellView(sportsEvent: SportsEvent) -> some View {
        
        VStack(alignment: .center) {
            
            Text(sportsEvent.timeRemainingInDaysHoursMinutesSeconds(currentDate: timerManager.currentDate))
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
                .onTapGesture {
                    model.updateFavourite(eventId: sportsEvent.eventId,
                                          sportId: sportsEvent.sportId)
                }
            
            Text(sportsEvent.eventName)
                .font(Font.system(size: 13, weight: .regular))
                .multilineTextAlignment(.center)
                .lineLimit(3)
            
            Spacer()

        }
        .padding(.top, 12)
        .frame(width: itemWidth)
        .bounceTap(withBorder: true,
                   extraBounce: false,
                   pressedBGColor: Color.clear,
                   theme: theme,
                   action: {
            onEventTap(sportsEvent)
        })
        
    }
    
}

#Preview {
    HorizontalListView(sportId: "sportId",
                       dataManager: DataManager.shared,
                       timerManager: TimerManager.shared,
                       theme: ThemeService.shared.selectedTheme,
                       itemWidth: 10.0,
                       onEventTap: { _ in })
}
