//
//  BounceTapModifier.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import SwiftUI

struct BounceDragModifier: ViewModifier {
    
    @State private var isPressed: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var shouldTriggerTap: Bool = true
    @State var withBorder: Bool = true
    @State var pressedBGColor: Color = .clear
    @State var extraBounce: Bool
    @ObservedObject var themeService = ThemeService.shared

    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .padding(.all, 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isPressed ? themeService.selectedTheme.mainTextColour : Color.clear, lineWidth: 2)
                    .shadow(color: isPressed ? themeService.selectedTheme.mainTextColour.opacity(0.5) : Color.clear, radius: 10)
                    .animation(.easeInOut(duration: 0.2), value: isPressed)
                    .opacity(withBorder && isPressed ? 1.0 : 0.0)
                    .padding(.all, 0)
            )
            .scaleEffect(isPressed ? (extraBounce ? 0.6 : 0.8) : 1.0)
            .background(pressedBGColor.cornerRadius(20).opacity(isPressed ? 1.0 : 0.0))
            .animation(.easeInOut(duration: 0.2), value: isPressed)
            .gesture(
                TapGesture() // Capture tap action only, let ScrollView take priority on drag
                    .onEnded {
                        if shouldTriggerTap {
                            isPressed = true // Start animation
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isPressed = false // Reset animation after action
                                action() // Trigger the action
                            }
                        }
                    }
            )
    }
}

extension View {
    
    func bounceTap(withBorder: Bool = true,
                   extraBounce: Bool = false,
                   pressedBGColor: Color = .clear, //ThemeService.shared.selectedTheme.gr,
                   action: @escaping () -> Void) -> some View {
        self.modifier(BounceDragModifier(withBorder: withBorder,
                                         pressedBGColor: pressedBGColor,
                                         extraBounce: extraBounce,
                                         action: action))
    }
    
    var anyView: AnyView {
        AnyView(self)
    }
    
    func onLoad(perform action: (() -> Void)? = nil) -> some View {
        var actionPerformed = false
        return self.onAppear {
            guard !actionPerformed else {
                return
            }
            actionPerformed = true
            action?()
        }
    }
    
    func fullBackground(imageName: String) -> some View {
        return background(
            Image(imageName)
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        )
        .edgesIgnoringSafeArea(.all)
    }
}
