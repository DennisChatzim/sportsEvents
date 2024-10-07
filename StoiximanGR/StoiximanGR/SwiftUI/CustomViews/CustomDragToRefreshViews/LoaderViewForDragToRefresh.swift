//
//  LoaderViewForDragToRefresh.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 7/10/24.
//

import SwiftUI

struct LoaderViewForDragToRefresh: View  {
    
    @State var rotationAngle: Double = 0.0
    @State var duration: CGFloat = 1.0
    @Binding var degrees: Double
    
    var body: some View {
        
        Image("footBall")
            .resizable()
            .scaledToFit()
            .background(Color.clear)
            .clipShape(Circle())
            .frame(width: 50, height: 50)
            .shadow(color: Color.blue, radius: 10)
            .rotationEffect(Angle.degrees(rotationAngle))
            .animation(.linear(duration: duration).repeatForever(autoreverses: false), value: rotationAngle)
            .onChange(of: degrees) { newDegress, _ in
                DispatchQueue.main.async {
                    if newDegress > 0 {
                        withAnimation {
                            self.rotationAngle = newDegress
                        }
                    }
                }
                // debugPrint("onChange: New position rotationAngle ? = \(rotationAngle), degressForRotationSpeed = \(newDegress)")
            }
  
    }
}

#Preview {
    LoaderViewForDragToRefresh(degrees: Binding<Double>(get: { return 360}, set: { _ in }))
}
