//
//  CustomTabBar.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import SwiftUI

enum Tab : String, CaseIterable {
    
    case sportsSwiftUI, sportsUIKit
    
    func rawValueIndex() -> Int {
        switch self {
        case .sportsSwiftUI: return 0
        case .sportsUIKit: return 1
        }
    }
    
    var nextTab: Tab {
        switch self {
        case .sportsSwiftUI: return .sportsSwiftUI
        case .sportsUIKit: return .sportsUIKit
        }
    }
    
    var previousTab: Tab {
        switch self {
        case .sportsSwiftUI: return .sportsUIKit
        case .sportsUIKit: return .sportsSwiftUI
        }
    }
    
    func imageNameSelected() -> String {
        switch self {
        case .sportsSwiftUI:
            return "swiftUIIcon"
        case .sportsUIKit:
            return "uiKitIcon"
        }
    }
    
    func imageNameDeselected() -> String {
        switch self {
        case .sportsSwiftUI:
            return "swiftUIIcon"
        case .sportsUIKit:
            return "uiKitIcon"
        }
    }
    
    func tabName() -> String {
        switch self {
        case .sportsSwiftUI:
            return "SwiftUI"
        case .sportsUIKit:
            return "UIKit"
        }
    }
    
}

struct CustomTabBar: View {
    
    @Binding var selectedTab: Tab
    @ObservedObject var themeService = ThemeService.shared

    @State var isAnimating = false
    @Namespace private var namespace
    @State private var scaleEffect: CGFloat = 1.0
    @State private var rotationDegrees: Double = 0.0
    var selectedTabBlock: (Tab) -> Void
    
    var body: some View {
        
        HStack {
            Spacer()
            tabBarItem(tab: Tab.sportsSwiftUI,
                       selectedTab: selectedTab,
                       action: {
                tabItemTapped(newTab: Tab.sportsSwiftUI)
            })
            Spacer()
            tabBarItem(tab: Tab.sportsUIKit,
                       selectedTab: selectedTab,
                       action: {
                tabItemTapped(newTab: Tab.sportsUIKit)
            })
            Spacer()
        }
        .frame(height: 60)
        .padding(.horizontal)
        .padding(.bottom, 25)
        .background(
            ZStack {
                themeService.selectedTheme.mainBGColor
                    .opacity(1.0) // Adjust opacity to control blending
                    .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
                    .animation(.easeInOut, value: themeService.selectedTheme) // Fade animation for theme changes
            }
                .edgesIgnoringSafeArea([.leading, .trailing, .bottom])
        )
        .overlay(
            VStack {
                Rectangle()
                    .fill(themeService.selectedTheme.mainBGColor)
                    .frame(height: 1)
                Spacer()
            }
        )
        
    }
    
    func tabItemTapped(newTab: Tab) {
        
        if !isAnimating {
            
            isAnimating = true
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.72, blendDuration: 0.3)) {
                scaleEffect = 1.3
                self.selectedTab = newTab
                self.rotationDegrees = -20
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                selectedTabBlock(newTab)
                                
                withAnimation(.easeOut(duration: 0.1)) {
                    scaleEffect = 1.0
                    self.rotationDegrees = 20
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAnimating = false
                    self.rotationDegrees = 0
                }
                
            }
            
        }
        
        
    }
    
    func tabBarItem(tab: Tab,
                    selectedTab: Tab,
                    action: @escaping () -> Void) -> some View {
        Button(action: {
            
            action()
    
        }) {
            
            VStack(spacing: 5) {
                
                if selectedTab == tab {
                    
                    Capsule()
                        .fill(Color.blue)
                        .frame(height: 3)
                        .scaleEffect(x: 0.5, anchor: .center)
                        .frame(alignment: .top)
                        .matchedGeometryEffect(id: "underline", in: namespace)
                    
                } else {
                    
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 3)

                }
                
                VStack(spacing: 2) {
                    
                    Image(selectedTab == tab ? tab.imageNameSelected() : tab.imageNameDeselected())
                        .resizable()
                        .scaledToFit()
                        .padding(.bottom, 4)
                        //.frame(width: 30, height: 30)
                        .foregroundColor(selectedTab == tab ? .blue : .gray)
                        .scaleEffect(selectedTab == tab ? scaleEffect : 1.0)
                        .frame(height: 36)
                        .rotationEffect(.degrees(selectedTab == tab ? rotationDegrees : 0.0))
                        .animation(selectedTab == tab ? .spring(response: 0.3, dampingFraction: 0.4) : .none, value: selectedTab == tab && isAnimating)

                    Text(tab.tabName())
                        .lineLimit(1)
                        .frame(width: 80, height: 14)
                        .font(Font.system(size: 13, weight: selectedTab == tab ? .bold : .regular))
                        .foregroundColor(selectedTab == tab ? .blue : .gray)

                }

            }
            .background(
                ZStack {
                    themeService.selectedTheme.mainBGColor
                        .allowsHitTesting(false)
                        .opacity(selectedTab == tab && isAnimating ? 0.3 : 0.0)
                        .animation(selectedTab == tab ? .easeOut(duration: 0.1) : nil, value: selectedTab == tab)
                }
            )
            
        }
    }
    
    var alarmButton: some View {
        Button(action: {
            print("Alarm button tapped")
        }) {
            Circle()
                .fill(Color.red)
                .frame(width: 60, height: 60)
                .overlay(
                    Text("Alarm")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                )
                .shadow(radius: 5)
        }
        .offset(y: -40)
    }
    
    
}
