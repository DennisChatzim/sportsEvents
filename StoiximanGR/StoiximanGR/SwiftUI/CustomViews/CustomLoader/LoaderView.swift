//
//  LoaderView.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 5/10/24.
//

import SwiftUI


struct LoaderView: View  {
    
    @State private var degree: Double = 270.0
    @State private var spinnerLength = 0.6
    @State private var duration = 0.7
    let radius: CGFloat = 20.0
    @State var ballsStyle = true
    @State var theme: Theme

    var body: some View {

        ZStack {
            
            theme.mainBGColor.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Circle()
                    .trim(from: 0.0, to: spinnerLength)
                    .stroke(LinearGradient(colors: [.blue, .green, .white, .blue],
                                           startPoint: .topLeading,
                                           endPoint: .bottomTrailing).opacity(ballsStyle ? 0.0 : 1.0),
                            style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                    .overlay(
                        Image("footBall")
                            .resizable()
                            .scaledToFit()
                            .background(Color.clear)
                            .clipShape(Circle())
                            .opacity(ballsStyle ? 1.0 : 0.0)
                            .shadow(color: Color.blue, radius: 10)
                    )
                    .animation(Animation.easeIn(duration: duration * 1.5).repeatForever(autoreverses: true), value: degree)
                    .frame(width: 60, height: 60)
                    .rotationEffect(Angle(degrees: Double(degree)))
                    .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: degree)
                    .overlay(
                        CircularLoaderView(shouldMoredots: true, theme: theme)
                            .overlay(
                                Circle()
                                    .trim(from: 0.0, to: spinnerLength)
                                    .stroke(LinearGradient(colors: [.blue, .black, .white, .blue],
                                                           startPoint: .topLeading,
                                                           endPoint: .bottomTrailing).opacity(ballsStyle ? 0.0 : 1.0),
                                            style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                                    .frame(width: 20, height: 20)
                                    .rotationEffect(Angle(degrees: -degree))
                                    .animation(Animation.easeOut(duration: duration).repeatForever(autoreverses: true), value: degree)
                                

                            )
                    )
                    .bounceTap(withBorder: false,
                               extraBounce: true,
                               pressedBGColor: Color.clear,
                               theme: theme,
                               action: { })
                    .allowsHitTesting(ballsStyle)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear{
                        degree = 270.0 + 360.0
                        spinnerLength = 0
                        duration = 1.0
                    }
                            
                Spacer().frame(height: 30)
                
                Text(LocalizedString.loadingText)
                    .font(Font.system(size: 24, weight: .medium))
                    .lineLimit(1)
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)

    }
}


#Preview {
    LoaderView(theme: ThemeService.shared.selectedTheme)
}

struct LoaderViewModifier: ViewModifier {
    
    @Binding var isLoading: Bool
    @State var theme: Theme
    
    func body(content: Content) -> some View {
        
        ZStack {
            content
                .allowsHitTesting(!isLoading)
                .overlay(
                    ZStack {
                        if isLoading {
                            LoaderView(theme: theme)
                                .opacity(1.0)
                                .animation(.easeInOut(duration: 0.3), value: isLoading)
                            
                        } else {
                            EmptyView()
                        }
                    }
                        .edgesIgnoringSafeArea(.all)
                        .allowsHitTesting(false)
                    
                )
        }
    }
}


extension View {
    
    func loaderView(isLoading: Binding<Bool>) -> some View {
        self.modifier(LoaderViewModifier(isLoading: isLoading,
                                         theme: ThemeService.shared.selectedTheme))
    }
    
    
}
