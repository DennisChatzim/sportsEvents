//
//  UIKitControllerWrapper.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 7/10/24.
//

import SwiftUI

// Wrapper to Present UIKit inside SwiftUI based TabView
struct UIKitControllerWrapper: UIViewControllerRepresentable {
    
    var myUIKitNavigationController = CustomNavigationController.init(rootViewController: EventsUIViewController())
    
    func makeUIViewController(context: Context) -> CustomNavigationController {
        return myUIKitNavigationController
    }
    
    func updateUIViewController(_ uiViewController: CustomNavigationController, context: Context) {}
}
