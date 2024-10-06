//
//  TimerManager.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 6/10/24.
//

import Foundation
import Combine

// TimerManager to update remaining time every second, it will be used only for swiftUI as ObservedObject to observe currentDate changes
class TimerManager: ObservableObject {
    
    static var shared = TimerManager()
    
    @Published var currentDate = Date()

    static var realtimeSecondsToUpdateRemainingTime: TimeInterval = 1.0
    
    init() {
        
        Timer.publish(every: TimerManager.realtimeSecondsToUpdateRemainingTime, on: .main, in: .common)
            .autoconnect()
            .assign(to: &$currentDate)
    }
}
