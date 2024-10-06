//
//  MainTabView.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import SwiftUI


struct MainTabView: View {
    
    @ObservedObject var navRouter = RouterNav()
    @ObservedObject var themeService = ThemeService.shared
    
    @State var tabViewSelection = 0
    @State private var selectedTab: Tab = .sportsSwiftUI
    @StateObject var sportsModel = SportsViewModel(dataManager: DataManager.shared, networkManager: NetworkManager.shared)
    
    var body: some View {
        
        ZStack {
                        
            ZStack {
                
                themeService.selectedTheme.mainBGColor
                    .edgesIgnoringSafeArea(.all)
                    .preferredColorScheme(themeService.selectedTheme.colorScheme)
                
                swiftUINavigationView

                uiKitWrapperController
                             
                VStack {
                    
                    Spacer()
                    
                    customTabBar
                    
                }
                .edgesIgnoringSafeArea(.bottom)
                
            }
            
        }
        
    }
    
    @ViewBuilder
    var sportsViewSwiftUI: SportsView {
        SportsView(themeService: themeService, model: sportsModel)
    }
    
    @ViewBuilder
    var sportsViewUIKit: CustomNavigationControllerWrapper {
        
        CustomNavigationControllerWrapper()
    }
    
    
    var customTabBar: CustomTabBar {
        return CustomTabBar(selectedTab: $selectedTab) { newTab in
            
            guard newTab == selectedTab else { return }
            
            navRouter.navigateBack()

        }
    }
    
    var swiftUINavigationView: some View {

        return NavigationStack(path: $navRouter.navPath) {
            
            sportsViewSwiftUI
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { toolbarItems(tintColour: themeService.selectedTheme.customNavigationBarItemTint) }
                .navigationDestination(for: RouterNav.Destination.self) { destination in
                    navRouter.destinationView(viewDestination: destination)
                }

        }
        .opacity(selectedTab == .sportsSwiftUI ? 1.0 : 0.0)
        .offset(x: selectedTab == .sportsSwiftUI ? 0.0 : -1.0 * UIScreen.main.bounds.width)
        .environment(\.router, navRouter)

    }
    
    var uiKitWrapperController: some View {
        ZStack {
            
            // This fixes the top safe area to have same bg colour as the navigation bar
            themeService.selectedTheme.navigationBarBackground
            
            sportsViewUIKit
            
        }
        .opacity(selectedTab == .sportsUIKit ? 1.0 : 0.0)
        .offset(x: selectedTab == .sportsUIKit ? 0.0 : 1.0 * UIScreen.main.bounds.width)
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
