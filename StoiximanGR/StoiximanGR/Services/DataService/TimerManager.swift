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

    // Ok so updating so many data Events = Views every second is not good idea
    // The reason that I kept it 2 second accuracy is that on real devices I didn't notice any performance issues, on simulator it has some minor scrolling gaps
    // I would suggest to change the format that requirements defined: "00:00:00" and keep the remaining time max accuracy to minutes instead of seconds !
    // We could then set this variable to 30 seconds (realtimeSecondsToUpdateRemainingTime) to improve a lot the scrolling performance and
    // Also we should change the format of remaining time to show always "DD:HH:MM" = Days-Hour-Minutes -> example: "1d:22h:46m"
    // I did this already for the events that will start in more than 1 day -> format will be: "1d:22h:46m"
    var realtimeSecondsToUpdateRemainingTime: TimeInterval = 2.0
    
    init() {
        
        Timer.publish(every: realtimeSecondsToUpdateRemainingTime, on: .main, in: .common)
            .autoconnect()
            .assign(to: &$currentDate)
    }
}
