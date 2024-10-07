//
//  CircularLoaderView.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import SwiftUI

struct CircularLoaderView: View {
    
    @State var shouldMoredots = false
    @State var theme: Theme
    
    let dotSize: CGFloat = 12.0
    let animationDuration: Double = 1.0 // Duration for the spring movement
    
    let rotationSpeed: Double = 1.2 // Slower rotation speed for the entire view
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0 // For rotating the entire view
    @State var ballsStyle = true
    
    // Number of dots and their size
    func dotCount() -> Int {
        return shouldMoredots ? 5 : 3
    }
    func movementDistance() -> CGFloat {
        return shouldMoredots ? 120.0 : 40.0
    }
        
    var body: some View {
        ZStack {
            ForEach(0..<dotCount(), id: \.self) { index in
                // Main dots
                Circle()
                    .fill(RadialGradient(colors: [.white, .blue, .blue, .blue, .blue, .blue],
                                         center: .center,
                                         startRadius: 0,
                                         endRadius: shouldMoredots ? dotSize : dotSize / 2.0).opacity(ballsStyle ? 0.0 : 1.0))
                    .stroke(ballsStyle ? Color.clear : Color.white, lineWidth: 1.0)
                    .overlay(
                        Image(shouldMoredots ? "footBall" : "basketBallBall")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(theme.mainTextColour)
                            .background(Color.clear)
                            .clipShape(Circle())
                            .shadow(color: Color.blue, radius: 4)
                            .opacity(ballsStyle ? 1.0 : 0.0)
                    )
                    .frame(width: ballsStyle ? 1.5 * dotSize : dotSize, height: ballsStyle ? 2 * dotSize : dotSize)
                    .overlay(
                        ZStack {
                            if shouldMoredots {
                                CircularLoaderView(shouldMoredots: false, theme: theme)
                            } else {
                                EmptyView()
                            }}
                    )
                    .offset(x: self.isAnimating ? self.calculateXMovement(for: index) : 0,
                            y: self.isAnimating ? self.calculateYMovement(for: index) : 0) // Move dots outward and back
                    .edgesIgnoringSafeArea(.all)
                    .animation(
                        .easeInOut(duration: ballsStyle ? 0.8 * animationDuration : animationDuration)
                        .repeatForever(autoreverses: true), value: isAnimating
                    )
            }
        }
        .rotationEffect(Angle.degrees(rotationAngle))
        .animation(shouldMoredots ? .none : .linear(duration: ballsStyle ? 2 * rotationSpeed: rotationSpeed).repeatForever(autoreverses: false), value: rotationAngle)
        .onAppear {
            self.isAnimating.toggle()
            withAnimation {
                self.rotationAngle = 360
            }
        }
    }
  
    // Calculate the outward X movement for each dot based on its angle
    private func calculateXMovement(for index: Int) -> CGFloat {
        let angle = angleFor(index)
        return movementDistance() * cos(angle) // Move outward
    }
    
    // Calculate the outward Y movement for each dot based on its angle
    private func calculateYMovement(for index: Int) -> CGFloat {
        let angle = angleFor(index)
        return movementDistance() * sin(angle) // Move outward
    }

    // Calculate the overlay X movement for additional dots based on the main dot's position
    private func calculateOverlayXMovement(for index: Int, subIndex: Int) -> CGFloat {
        let angle = angleFor(index)
        let overlayAngle = angle + angleOffset(for: subIndex)
        
        // Base positions of the blue dot
        let baseX = calculateXMovement(for: index)
        // Calculate the outward explosion position for red dots from their blue dot's center
        return baseX + (movementDistance() * 0.5 * cos(overlayAngle))
    }

    // Calculate the overlay Y movement for additional dots based on the main dot's position
    private func calculateOverlayYMovement(for index: Int, subIndex: Int) -> CGFloat {
        let angle = angleFor(index)
        let overlayAngle = angle + angleOffset(for: subIndex)

        // Base positions of the blue dot
        let baseY = calculateYMovement(for: index)
        // Calculate the outward explosion position for red dots from their blue dot's center
        return baseY + (movementDistance() * 0.5 * sin(overlayAngle))
    }
    
    // Calculate the angle for each dot
    private func angleFor(_ index: Int) -> CGFloat {
        let degreesPerDot = 360.0 / Double(dotCount())
        return CGFloat(degreesPerDot * Double(index)) * .pi / 180 // Convert degrees to radians
    }

    // Offset angle for overlay dots
    private func angleOffset(for subIndex: Int) -> CGFloat {
        let degreesPerSubDot = 360.0 / 5.0 // Offset for 5 overlay dots
        return CGFloat(degreesPerSubDot * Double(subIndex)) * .pi / 180 // Convert degrees to radians
    }
}

struct CircularLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        CircularLoaderView(theme: ThemeService.shared.selectedTheme)
    }
}


#Preview {
    CircularLoaderView(theme: ThemeService.shared.selectedTheme)
}
