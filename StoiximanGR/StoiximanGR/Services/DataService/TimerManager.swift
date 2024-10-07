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
    
    // Added two different timers to improve performance and update only the visible View time remaing, When UIKit tab is selected only currentDateUIKit when SwiftUIScreen is selected only currentDateSwiftUI will be updated
    @Published var currentDateUIKit = Date()
    @Published var currentDateSwiftUI = Date()
    private var disposeBag: DisposeBagForCombine = []

    // Ok so updating so many data Events = Views every second is not good idea
    // The reason that I kept it 1 second accuracy is that on real devices I didn't notice any performance issues, on simulator it has some minor scrolling gaps
    // I would suggest to change the format that requirements defined: "00:00:00" and keep the remaining time max accuracy to minutes instead of 1 second !
    // We could then set this variable to 30 seconds (realtimeSecondsToUpdateRemainingTime) to improve a lot the scrolling performance and
    // Also we should change the format of remaining time to show always "DD:HH:MM" = Days-Hour-Minutes -> example: "1d:22h:46m"
    // I did this already for the events that will start in more than 1 day -> format will be: "1d:22h:46m"
    var realtimeSecondsToUpdateRemainingTime: TimeInterval = 1.0
    
    @Published var isUIKitTimerEnabled = true

    init() {
        
        $isUIKitTimerEnabled
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isUIKitTimerEnabled in
                guard let instance = self else { return }
              
                let timer = Timer.publish(every: instance.realtimeSecondsToUpdateRemainingTime, on: .main, in: .common).autoconnect()
                
                if isUIKitTimerEnabled {
                    
                    timer.assign(to: &instance.$currentDateUIKit)

                } else {
                    
                    timer.assign(to: &instance.$currentDateSwiftUI)

                }
                
            })
            .store(in: &disposeBag)
        
    }

    func enableOnlyUIKitTimer(onlyUIKit: Bool) {
        isUIKitTimerEnabled = onlyUIKit
    }
}
