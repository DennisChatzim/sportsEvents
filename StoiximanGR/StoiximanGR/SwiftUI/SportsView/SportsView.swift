//
//  MainView.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import Foundation
import SwiftUI

struct SportsView: View {
    
    @Environment(\.router) var navRouter

    @ObservedObject var themeService: ThemeService // Keep ThemeService singletons in Views and DataManager to models
    @ObservedObject var model: SportsViewModel
    @State private var position: CGFloat = 0.0
    
    var maxDraggingToRefreshHeight = min(200, UIScreen.main.bounds.height * 0.8)
    
    var body: some View {
        
        ZStack {
            
            ZStack {
                
                ZStack {
                    
                    ScrollviewWithOffsetDetection {
                        
                        allCategoriesView(width: getEventCellWidth())
                        
                    }
                    onScroll: { newPosition in
                        
                        handleNewScrollingPosition(newPosition: newPosition)
                        
                    }
                    .preferredColorScheme(themeService.selectedTheme.colorScheme)
                    .animation(.easeInOut(duration: 0.5), value: themeService.selectedTheme)
                    .background(themeService.selectedTheme.mainBGColor)
                    .animation(.easeInOut(duration: 0.5), value: themeService.selectedTheme)
                    .dragToRefresh(isLoading: $model.isLoading,
                                   position: $position)
                    // Refreshable is buggy in swiftUI because sometimes it stays spinning even after refresh is done.
                    // And this is why I decided to buld my own drag to refresh feature for you ! - > Look inside "CustomDragToRefreshView" and "dragToRefresh"
                    // .refreshable { Task { await model.loadData() } }
                    .loaderView(isLoading: $model.isLoading)
                      
                }
                
            }
            
        }
        .onAppear {
            tryLoadingData()
        }
        .alert(LocalizedString.errorNetworkAlertTitle,
               isPresented: $model.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(model.errorMessage ?? "Error")
        }
    }
    
    func tryLoadingData() {
        if model.allCategories.isEmpty {
            Task {
                await model.loadData()
            }
        }
    }
    
    @ViewBuilder // We use this for faster rendering and helping SwiftUI when the view contains multiple internal views !
    func allCategoriesView(width: CGFloat) -> some View {
        
        LazyVStack(spacing: 0) {
        
            ForEach(model.allCategories, id: \.self) { category in
                
                Section(header: categoryHeader(for: category)) {
                    
                    if !model.isCategoryCollapsed(category: category) {
                        
                        HorizontalListView(sportId: category.sportId,
                                           dataManager: model.dataManager,
                                           theme: themeService.selectedTheme,
                                           itemWidth: width,
                                           onEventTap: { sportsEvent in
                            navRouter.navigate(to: .eventDetails(sportsEvent: sportsEvent, themeService: themeService))
                        })
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(Animation.easeIn(duration: 0.3), value: model.isCategoryCollapsed(category: category))

                    }
                }

            }
        }
        .padding(.top, 5)
        .padding(.bottom, 150)
    }
    
    @ViewBuilder
    private func categoryHeader(for category: SportsCategory) -> some View {
        
        VStack(spacing: 0.0) {
            
            HStack {
                
                Image(SportsCategory.getIconNameFor(sportId: category.sportId))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .foregroundColor(themeService.getTintColor(sportId: category.sportId))
                
                Text(category.categoryName + (model.isCategoryCollapsed(category: category) ? " (\(category.allEventsOfThisCategory.count) events)" : ""))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(themeService.selectedTheme.customTextColour)
                
                Spacer()
                
                Image(systemName: "chevron.up")
                    .rotationEffect(model.isCategoryCollapsed(category: category) ? .degrees(180) : .degrees(0))
                    .foregroundColor(themeService.selectedTheme.customTextColour)
                    .frame(width: 24)
                    .animation(.easeInOut, value: model.isCategoryCollapsed(category: category))
                
            }
            .padding(8)

            Rectangle()
                .stroke(Color.gray.opacity(0.4), lineWidth: 0.8)
                .frame(height: 0.8)
                .opacity(model.isCategoryCollapsed(category: category) ? 1.0 : 0.0)
            
        }
        .contentShape(Rectangle()) // Makes the whole area tappable
        .background(themeService.selectedTheme.sectionsHeaderColor)
        .animation(.easeInOut(duration: 0.5), value: themeService.selectedTheme)
        .onTapGesture {
            debugPrint("Tapped category id = \(category.sportId)")
            withAnimation(Animation.linear(duration: 0.3)) {
                model.toggleCategoryVisibility(category)
            }
        }
    }
    
    func handleNewScrollingPosition(newPosition: CGFloat) {
        
        //debugPrint("Dragging now with newPosition = \(newPosition)")
        
        guard newPosition >= 0.0 else {
            self.position = 0.0
            return
        }
        self.position = newPosition
        if position > maxDraggingToRefreshHeight {
            model.isLoading = true
            self.position = 0.0
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // I added delay dor Demo purposes only to show the extreme spinner I build for you
                Task {
                    await model.loadData()
                }
            }
        }
        
    }
    
}
 
#Preview {
    SportsView(themeService: ThemeService.shared,
               model: SportsViewModel(dataManager: DataManager.shared,
                                      networkManager: NetworkManager.shared))
}
