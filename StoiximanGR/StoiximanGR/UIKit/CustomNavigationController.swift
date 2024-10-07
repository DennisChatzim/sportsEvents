//
//  CustomNavigationController.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import Foundation
import UIKit
import SwiftUI

class CustomNavigationController: UINavigationController {
    
    var themeService = ThemeService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // I did this here only for Demo purposes in order to keep UIKit implementation pure and not affected by the SwiftUI parts
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(themeService.selectedTheme.navigationBarBackground)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.tintColor = UIColor.white
        
    }
    
    // Ensure inline style is always used
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.largeTitleDisplayMode = .never
        super.pushViewController(viewController, animated: animated)
    }
    
}
