//
//  CustomDragToRefresh.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 7/10/24.
//

import SwiftUI

struct CustomDragToRefreshView: View {
    
    @Binding var isLoading: Bool
    @Binding var position: CGFloat
    @State var degressForRotationSpeed: Double = 0.0
    var maxDraggingToRefreshHeight = min(200, UIScreen.main.bounds.height * 0.8)
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                HStack {
                    
                    Spacer()
                    
                    getDragArrowIndicators()
                    
                    Spacer().frame(width: 30)
                    
                    LoaderViewForDragToRefresh(degrees: $degressForRotationSpeed)
                        .onChange(of: position) { newPosition, _ in
                            degressForRotationSpeed = position / maxDraggingToRefreshHeight * (4 * 360)
                            // debugPrint("onChange: New position CustomDragToRefreshView ? newPosition = \(newPosition), degressForRotationSpeed = \(degressForRotationSpeed)")
                        }
                        .padding(.top, 10)
                        .offset(x: 0, y: isLoading ? UIScreen.main.bounds.height / 2.2 : (position * 1.4 / maxDraggingToRefreshHeight) * 15)
                        .opacity(min(1, position > 10.0 ? abs(position * 1.4 / maxDraggingToRefreshHeight) : 0.0))
                        .scaleEffect(x: isLoading ? 1 : min(1, abs(position / maxDraggingToRefreshHeight)) + 0.2,
                                     y: isLoading ? 1 : min(1, abs(position / maxDraggingToRefreshHeight)) + 0.2)
                        .animation(Animation.easeOut(duration: 0.7), value: position > 0 || isLoading) // Avoid animation when not needed, only when position > 0 or Loading we will need it
                    
                    Spacer().frame(width: 30)
                    
                    getDragArrowIndicators()
                    
                    Spacer()
                    
                }
                .opacity(position > 10.0 ? 1.0 : 0.0)
                .offset(y: max(0, abs(position / maxDraggingToRefreshHeight) * 10))
                .animation(.easeInOut(duration: 0.3), value: position)
                
                Spacer()
            }
            .onAppear {
                degressForRotationSpeed = position / maxDraggingToRefreshHeight * (4 * 360)
                debugPrint("New position CustomDragToRefreshView ? = \(position), degressForRotationSpeed = \(degressForRotationSpeed)")
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

struct DragToRefreshViewModifier: ViewModifier {
    
    @Binding var isLoading: Bool
    @Binding var position: CGFloat

    func body(content: Content) -> some View {
        
        ZStack {
            content
                .overlay(
                    ZStack {
                        CustomDragToRefreshView(isLoading: $isLoading,
                                                position: $position)
                    }
                )
        }
    }
}

extension View {
    
    func dragToRefresh(isLoading: Binding<Bool>,
                       position: Binding<CGFloat>) -> some View {
        
        self.modifier(DragToRefreshViewModifier(isLoading: isLoading,
                                                position: position))
    }
    
    
}
