//
//  RouterNavigation.swift
//  Stoiximan
//
//  Created by Dionisis Chatzimarkakis on 4/10/24.
//

import SwiftUI

struct RouterKey: EnvironmentKey {
    static let defaultValue: RouterNav = RouterNav()
}

extension EnvironmentValues {
    var router: RouterNav {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
