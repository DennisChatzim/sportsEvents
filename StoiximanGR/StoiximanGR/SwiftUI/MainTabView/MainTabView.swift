//
//  MainTabView.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var navRouter = RouterNav()
    
    // Lets try to keep the initial acces of all singleton in one place -> Here is the best one because MainTabView is the Parent of ALL internal Views and
    // we will try to pass the singletons to child Views and models
    @StateObject var themeService = ThemeService.shared
    @State var timerManager = TimerManager.shared // We don't want to declare it as "StateObject" because SwiftUI will re-Render the entire swiftUINavigationView every 1 second !
        
    // We need to create it and keep it here as variable of parent view of SportsView = MainTabView because:
    // 1.. When switching tabs we don't want to recreate the model of SportsView, we want the app to remember the model data, favourites etc of the SportsViewModel to have smooth and consistent UI
    // 2.. SwiftUI will by default will recreate the SportsViewModel of the SportsView inside this class if we just pass it as a new
    // instance like this: SportsView(themeService: themeService, model: SportsViewModel(dataManager: DataManager.shared, networkManager: NetworkManager.shared))
    // This is why we keep it as @StateObject and create SportsView like this: SportsView(themeService: themeService, model: sportsModel)
    @StateObject var sportsModel = SportsViewModel(dataManager: DataManager.shared, networkManager: NetworkManager.shared)
    
    @State var tabViewSelection = 0
    @State private var selectedTab: Tab = .sportsUIKit

    var body: some View {
        
        ZStack {
                        
            ZStack {
                                
                uiKitWrapperController
                
                swiftUINavigationView

                VStack {
                    
                    Spacer()
                    
                    customTabBar
                    
                }
                .edgesIgnoringSafeArea(.bottom)
                
            }
            
        }
        
    }
    
    var sportsViewUIKit: some View {
        
        CustomNavigationControllerWrapper()
            .preferredColorScheme(themeService.selectedTheme.colorScheme)
            .animation(.easeInOut(duration: 0.5), value: themeService.selectedTheme)

    }
    
    var uiKitWrapperController: some View {

        ZStack {
                        
            sportsViewUIKit

        }
        .opacity(selectedTab == .sportsUIKit ? 1.0 : 0.0)
        .offset(x: selectedTab == .sportsUIKit ? 0.0 : -1.0 * UIScreen.main.bounds.width)
    }
    
    var swiftUINavigationView: some View {
        
        return ZStack {
            
            NavigationStack(path: $navRouter.navPath) {
                
                sportsViewSwiftUI
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { toolbarItems(tintColour: themeService.selectedTheme.customNavigationBarItemTint) }
                    .navigationDestination(for: RouterNav.Destination.self) { destination in
                        navRouter.destinationView(viewDestination: destination)
                    }
                    .onAppear {
                        
                        let appearance = UINavigationBarAppearance()
                        appearance.configureWithOpaqueBackground()
                        appearance.backgroundColor = UIColor(themeService.selectedTheme.navigationBarBackground)
                        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                        
                        UINavigationBar.appearance().standardAppearance = appearance
                        UINavigationBar.appearance().scrollEdgeAppearance = appearance
                        UINavigationBar.appearance().compactAppearance = appearance
                        UINavigationBar.appearance().tintColor = UIColor.white // Set bar button item color
                    }

            }
            
        }
        .opacity(selectedTab == .sportsSwiftUI ? 1.0 : 0.0)
        .offset(x: selectedTab == .sportsSwiftUI ? 0.0 : 1.0 * UIScreen.main.bounds.width)
        .environment(\.router, navRouter)

    }
    
    var sportsViewSwiftUI: some View {
        SportsView(themeService: themeService,
                   timerManager: timerManager,
                   model: sportsModel)
    }
    
    var customTabBar: CustomTabBar {
        
        return CustomTabBar(selectedTab: $selectedTab,
                            theme: themeService.selectedTheme) { newTab in
            
            guard newTab == selectedTab else { return }
            
            // If user is inside Event details view and tab the tab item we should navigation back !
            navRouter.navigateBack()

        }
    }
    
    @ToolbarContentBuilder
    func toolbarItems(tintColour: Color) -> some ToolbarContent {
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                
                debugPrint("Opening Profile..")
                
            }) {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(tintColour)
                    .frame(width: 22)
            }
        }
        
        // This is needed in order to keep logo centered without making any calculations based on parent View wdth etc
        ToolbarItem(placement: .navigationBarLeading) {
            Spacer().frame(width: 22)
        }
        
        ToolbarItem(placement: .principal) {
            HStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .background(Color.clear)
                Spacer()
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                themeService.selectedTheme = themeService.selectedTheme == .dark ? .light : .dark
                
            }) {
                Image(systemName: themeService.selectedTheme == .dark ? "moon.fill" : "sun.max.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(tintColour)
                    .frame(width: 22)
            }
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                
                debugPrint("Opening settings..")
                
            }) {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(tintColour)
                    .frame(width: 22)
            }
        }
    }
    
}



#Preview {
    MainTabView()
}

// Wrapper to Present UIKit in SwiftUI
struct CustomNavigationControllerWrapper: UIViewControllerRepresentable {
    
    var myUIKitNavigationController = CustomNavigationController.init(rootViewController: EventsUIViewController())
    
    func makeUIViewController(context: Context) -> CustomNavigationController {
        return myUIKitNavigationController
    }
    
    func updateUIViewController(_ uiViewController: CustomNavigationController, context: Context) {}
}
