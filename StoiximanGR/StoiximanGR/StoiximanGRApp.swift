
//
//  StoiximanApp.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import SwiftUI

/*

Initial Requirements :
● The application is required to retrieve the list of events from an API endpoint. Further details regarding the API can be found in the API section provided below.
● Events should be presented in a scrollable list, categorized by sport type. Each event entry should include information about the competitors, a countdown timer indicating the time remaining until the event starts, and a favorite button.
● Users must have the ability to mark events as favorites. Favorited events should be prioritized and displayed first within their respective category. Persistence of favorite events beyond a single runtime is not necessary; marking them as favorites temporarily for the duration of a single session suffices.
● The countdown timer should update in real-time, accurately reflecting the remaining time until the event commences.
● A navigation bar containing the application's name or logo is mandatory.
● Users should be able to expand and collapse the events container based on their sport
type.
● The deliverable for this task is an Xcode project capable of being built and run on both a
simulator and a physical device.
● The main view with the list of sports needs to be implemented using UIKit (UITableview
or UICollectionView).
● Use Xcode 15.x
        

 Extra features that I added and were not requested:

 1. SwiftUI implementation of same (and a lot of extras) functionality with shared models and services as used by UIKit implementation

 2. Theme support Dark/Light with a button on the top right side to switch between the two of them

 3. Details screen for each event with navigation

 4. Tab bar screen wich includes both implementations SwiftUI and UIKit using a wrapper class between UIKit based controller and SwiftUI

 5. Custom tab bar with animations on the buttons and also the screens selections coming from left and right

 7. Custom extreme spinner with sports style using icons for balls of football, basketball etc

 8. Custom drag to refresh feature with custom arrows and footbal icon spinner plus extra animation when loading stars etc !

 6. Added basic Unit tests for the main services, please check: SportsViewModelTests, DataManagerTests, TestSportsViewDetailsModel

 7. Added support for localization of all texts shown and added only Greek and English languages
 
 
 Notes by dionisis for swiftUI version of the assignment:

 1. Default sorting order is kept so whenever a favourite event becomes not favourite again and also has SAME date with other events we re-sort the events based on the initial order of the events received by the server
    Please search for: defaultPriorityIndex

 2. SwiftUI has some strange behaviours when dealing with Observed objects and it keeps rendering the View non stop causing performance issues.
    This is the reason that I kept this model in the parent class of SportsView (Parent = MainTabView):
    @StateObject var sportsModel = SportsViewModel(dataManager: DataManager.shared, networkManager: NetworkManager.shared)

 3. Don't be confused between the View you see in SwiftUI tab and in UIKit.
    They look identical NOT because they have the same code but because I worked hard in order
    to make the same pixel perfect result with both approaches UIkit and SwiftUI !

 4. Please try to notice that no matter from which screen (SwiftUI or UIKit) you change the favourite settings the data are always updated smoothly and with consistency in both scenarios: Drag to refresh and also add/remove favourite
 
 5. This project can run only on iOS >= 17.0 because of some swiftUI functions
 
 */


@main
struct StoiximanApp: App {
    
    @ObservedObject var themeService = ThemeService.shared
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                mainView
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
    
    @ViewBuilder var mainView: some View {

        MainTabView()

    }
}
