//
//  ThemeService.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import SwiftUI

class ThemeService: ObservableObject, Codable, Equatable, Hashable {
    
    static let shared = ThemeService()
    
    @Published var isDarkThemeActive = false
    @Published var selectedTheme: Theme = .dark
    var disposeBag: DisposeBagForCombine = []
    
    init() {
        
        $selectedTheme.map { $0 == .dark ? true : false }.assign(to: &$isDarkThemeActive)
        
    }
    
    // MARK: Make specific tint on the category icon based on the category
    func getTintColor(sportId: String) -> Color {

        switch sportId {
        case "FOOT":
            return selectedTheme.mainTextColour
        case "BASK":
            return Color.clear
        case "TENN":
            return Color.clear
        case "VOLL":
            return Color.clear
        case "DART":
            return selectedTheme.mainTextColour
        case "TABL":
            return Color.clear
        case "ESPS":
            return selectedTheme.mainTextColour
        case "ICEH":
            return selectedTheme.mainTextColour
        case "SNOO":
            return selectedTheme.mainTextColour
        case "HAND":
            return selectedTheme.mainTextColour
        default:
            return selectedTheme.mainTextColour
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(isDarkThemeActive)
        hasher.combine(selectedTheme)
    }
    
    static func == (lhs: ThemeService, rhs: ThemeService) -> Bool {
        return lhs.isDarkThemeActive == rhs.isDarkThemeActive && lhs.selectedTheme == rhs.selectedTheme
    }
    
    
    // Encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isDarkThemeActive, forKey: .isDarkThemeActive)
        try container.encode(selectedTheme.rawValue, forKey: .selectedTheme)
    }
    
    // Decoding
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isDarkThemeActive = try container.decode(Bool.self, forKey: .isDarkThemeActive)
        let selectedThemeString = try container.decode(String.self, forKey: .selectedTheme)
        self.selectedTheme = Theme(rawValue: selectedThemeString) ?? .dark
    }
    
    // Coding Keys
    enum CodingKeys: String, CodingKey {
        case isDarkThemeActive
        case selectedTheme
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
