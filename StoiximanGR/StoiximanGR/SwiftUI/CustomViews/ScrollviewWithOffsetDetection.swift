//
//  ScrollviewwithOffsetDetection.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//

import SwiftUI

// Right now (7 October 2024) this is our best choice to detect dragging offset in SwiftUI ScrollView:

struct ScrollviewWithOffsetDetection<Content>: View where Content: View {
    
    let axes: Axis.Set = .vertical
    let content: () -> Content
    let onScroll: (CGFloat) -> Void
    
    var body: some View {
        ScrollView(axes) {
            content()
                .background(
                    GeometryReader { proxy in
                        let position = (
                            axes == .vertical ?
                            proxy.frame(in: .named("scrollID")).origin.y :
                            proxy.frame(in: .named("scrollID")).origin.x
                        )
                        
                        Color.clear
                            .onChange(of: position) { position, _ in
                                onScroll(position)
                            }
                    }
                )
        }
        .coordinateSpace(.named("scrollID"))
    }
}
