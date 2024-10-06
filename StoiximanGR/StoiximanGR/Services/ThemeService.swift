//
//  ThemeService.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import SwiftUI

class ThemeService: ObservableObject {
  
    static let shared = ThemeService()
    
    @Published var isDarkThemeActive = false
    @Published var selectedTheme: Theme = .dark
    var disposeBag: DisposeBagForCombine = []

    init() {
        
        $selectedTheme.map { $0 == .dark ? true : false }.assign(to: &$isDarkThemeActive)
        
        $selectedTheme
            .sink(receiveValue: { _ in
 
                let coloredAppearance = UINavigationBarAppearance()
                coloredAppearance.configureWithTransparentBackground()
                
                coloredAppearance.backgroundColor = UIColor(named: "navigationBarBG") ?? .red
                coloredAppearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
                
                coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white as Any]
                coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white as Any]
                
                UINavigationBar.appearance().tintColor = UIColor.white
                
                UINavigationBar.appearance().standardAppearance = coloredAppearance
                UINavigationBar.appearance().compactAppearance = coloredAppearance
                UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance

            })
            .store(in: &disposeBag)
        
        
    }
    
}

enum Theme: String, CaseIterable {
    
    case light, dark
    
    var mainTextColour: Color {
        switch self {
        case .light: return Color.init(white: 0.0, opacity: 1.0)
        case .dark: return Color.init(white: 1.0, opacity: 1.0)
        }
    }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    var mainBGColor: Color {
        return Color("mainBGColor")
    }
    
    var navigationBarBackground: Color {
        return Color("navigationBarBG")
    }

    var sectionsHeaderColor: Color {
        return Color("sectionsHeaderColor")
    }
    
    var customTextColour: Color {
        return Color("textColour")
    }
    
    var favouriteActiveColour: Color {
        return Color.yellow
    }
    
    var favouriteInactiveColour: Color {
        return Color.gray
    }
    
    var customNavigationBarItemTint: Color {
        return Color.white
    }
    
    var tabItemsSelectedTint: Color {
        return Color.blue
    }

    var tabItemsNotSelectedTint: Color {
        return Color.gray
    }

}
