//
//  BackButtonView.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import SwiftUI

struct BackButtonView: View {
    
    var backAction: () -> Void
    
    var body: some View {
        Button(action: backAction) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.blue)
                Text("Back")
                    .foregroundColor(Color.blue)
                    .offset(x: -5)
            }
        }
    }
}

#Preview {
    BackButtonView(backAction: { })
}
