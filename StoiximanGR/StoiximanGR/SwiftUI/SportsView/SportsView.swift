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
    @ObservedObject var themeService: ThemeService
    @ObservedObject var model: SportsViewModel
    @State private var position: CGFloat = 0.0
    var maxDraggingToRefreshHeight = min(200, UIScreen.main.bounds.height * 0.8)

    var body: some View {
        
        ZStack {
                        
            ZStack {

                GeometryReader { geometry in
                    
                    ZStack {
                        
                        ScrollviewWithOffsetDetection {
                            
                            LazyVStack(spacing: 0) {
                            
                                ForEach(model.allCategories, id: \.self) { category in
                                    
                                    Section(header: categoryHeader(category)) {
                                        
                                        if !model.isCollapsed(category: category) {
                                            
                                            HorizontalListView(sportId: category.sportId,
                                                               dataManager: DataManager.shared,
                                                               themeService: themeService,
                                                               itemWidth: geometry.size.width / 4.0,
                                                               onEventTap: { sportsEvent in
                                                navRouter.navigate(to: .eventDetails(sportsEvent: sportsEvent))
                                            })
                                            .transition(.move(edge: .top).combined(with: .opacity))
                                            .animation(Animation.easeIn(duration: 0.3), value: model.isCollapsed(category: category))

                                        }
                                    }

                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 150)

                        }
                        onScroll: { newPosition in
                            
                            //debugPrint("Dragging now with newPosition = \(newPosition)")
                            
                            guard newPosition >= 0.0 else {
                                self.position = 0.0
                                return
                            }
                            self.position = newPosition
                            if position > maxDraggingToRefreshHeight {
                                model.isLoading = true
                                self.position = 0.0
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { // For Demo purposes only
                                    Task {
                                        await model.loadData()
                                    }
                                }
                            }
                        }
                        .overlay(refreshableViews)
                        // Refreshable is buggy in swiftUI because sometimes it stays spinning even after refresh is done.
                        // And this is why I decided to buld my own drag to refresh feature ! - > Look inside "refreshableViews"
//                        .refreshable {
//                            model.isLoading = true
//                            Task {
//                                await model.loadData()
//                            }
//                       }
                        .loaderView(isLoading: $model.isLoading)

                    }
                    
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
        .background(themeService.selectedTheme.mainBGColor)
        
    }
    
    func tryLoadingData() {
        if model.allCategories.isEmpty {
            Task {
                await model.loadData()
            }
        }
    }
    
    @ViewBuilder
    private func categoryHeader(_ category: SportsCategory) -> some View {
        
        VStack(spacing: 0.0) {
            
            HStack {
                
                Image(SportsCategory.getIconNameFor(sportId: category.sportId))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22)
                    .foregroundColor(SportsCategory.getTintColor(sportId: category.sportId))
                
                Text(category.categoryName + (model.isCollapsed(category: category) ? " (\(category.allEventsOfThisCategory.count) events)" : ""))
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(themeService.selectedTheme.customTextColour)
                
                Spacer()
                
                Image(systemName: "chevron.up")
                    .rotationEffect(model.isCollapsed(category: category) ? .degrees(180) : .degrees(0))
                    .foregroundColor(themeService.selectedTheme.customTextColour)
                    .frame(width: 24)
                    .animation(.easeInOut, value: model.isCollapsed(category: category))
                
            }
            .padding(8)

            Rectangle()
                .stroke(Color.gray.opacity(0.4), lineWidth: 0.8)
                .frame(height: 0.8)
                .opacity(model.isCollapsed(category: category) ? 1.0 : 0.0)
            
        }
        .background(themeService.selectedTheme.sectionsHeaderColor)
        .contentShape(Rectangle()) // Makes the whole area tappable
        .onTapGesture {
            debugPrint("Tapped category id = \(category.sportId)")
            withAnimation(Animation.linear(duration: 0.3)) {
                model.toggleCategoryVisibility(category)
            }
        }
    }
    
    private var refreshableViews: some View {
        
        ZStack {
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    getDragArrowIndicators()
                    
                    Spacer().frame(width: 30)

                    LoaderViewForDragToRefresh()
                        .padding(.top, 10)
                        .offset(x: 0, y: model.isLoading ? UIScreen.main.bounds.height / 2.2 : (position * 1.4 / maxDraggingToRefreshHeight) * 15)
                        .opacity(min(1, position > 10.0 ? abs(position * 1.4 / maxDraggingToRefreshHeight) : 0.0))
                        .scaleEffect(x: model.isLoading ? 1 : min(1, abs(position / maxDraggingToRefreshHeight)) + 0.2,
                                     y: model.isLoading ? 1 : min(1, abs(position / maxDraggingToRefreshHeight)) + 0.2)
                        .animation(Animation.easeOut(duration: 0.6), value: position) //model.isLoading && position >= 0)

                    Spacer().frame(width: 30)
                    
                    getDragArrowIndicators()
                                        
                    Spacer()
                    
                }
                .offset(y: max(0, abs(position / maxDraggingToRefreshHeight) * 30))
                
                Spacer()
            }
        }
        .allowsHitTesting(false)
    }
    
    func getDragArrowIndicators() -> some View {
        
        Image(systemName: "arrow.down")
            .resizable()
            .scaledToFit()
            .foregroundColor(Color.blue)
            .background(Color.clear)
            .frame(width: min(35, abs(position / maxDraggingToRefreshHeight * 30) + 10),
                   height: min(35, abs(position / maxDraggingToRefreshHeight * 30) + 10))
            .offset(x: 0, y: (position * 1.4 / maxDraggingToRefreshHeight) * 15 )
            .opacity(min(1, position > 10.0 ? abs(position * 1.4 / maxDraggingToRefreshHeight) : 0.0))
            .padding(.top, 10)

    }
    
}
 
#Preview {
    SportsView(themeService: ThemeService.shared, model: SportsViewModel(dataManager: DataManager.shared, networkManager: NetworkManager.shared))
}
