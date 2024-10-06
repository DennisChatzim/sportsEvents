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
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        // Custom background color
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(themeService.selectedTheme.navigationBarBackground)

        // Set title text attributes to inline style
        appearance.titleTextAttributes = [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.white
        ]
        
        // Hide default large title
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.clear]
        
        // Remove shadow and separator line
        appearance.shadowImage = UIImage()
        appearance.shadowColor = nil
        
        // Assign appearance to the navigation bar
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        // Ensure the navigation bar background is set correctly
        navigationBar.backgroundColor = UIColor(themeService.selectedTheme.navigationBarBackground)
        navigationBar.isTranslucent = false
        
    }
        
    // Ensure inline style is always used
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.largeTitleDisplayMode = .never
        super.pushViewController(viewController, animated: animated)
    }
    
}
