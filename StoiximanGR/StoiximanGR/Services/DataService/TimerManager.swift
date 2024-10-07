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
    var realtimeSecondsToUpdateRemainingTime: TimeInterval {
           return 1.0
    }
    
    private var timer: Cancellable?
    
    @Published var isUIKitTimerEnabled = true

    init() {
        
        setupTimerObserver()
        
    }
    
    private func setupTimerObserver() {
        
        $isUIKitTimerEnabled
            // .receive(on: DispatchQueue.main) // This is not needed: Lets avoid observing in mainn thread whenever possible. We have only 2 subscriber of date objects:
            // UIKit observes it using "sink" in main thread inside "EventCellUIKit"
            // SwiftUI observes date through the SwiftUI mechanism for "ObservedObjects" which iccurs always in mainthready anyway
            // So no need to observe here in main thread ;)
            .sink(receiveValue: { [weak self] isUIKitTimerEnabled in
                guard let instance = self else { return }
                
                instance.timer?.cancel()
                instance.timer = nil
                // I did this change to help the UI having even better prformance
                // The event Views will not be updated in both Screens (SwiftUI and UIkit), will be updaed only the current visible one by updating the corrent date object and observing accordingly from each view
                // UIKit implementation will observe "currentDateUIKit"
                // SwiftUI implementation will observe: "currentDateSwiftUI"
                if isUIKitTimerEnabled {
                    instance.timer = Timer.publish(every: instance.realtimeSecondsToUpdateRemainingTime, on: .main, in: .common).autoconnect().assign(to: \.currentDateUIKit, on: instance)
                } else {
                    instance.timer = Timer.publish(every: instance.realtimeSecondsToUpdateRemainingTime, on: .main, in: .common).autoconnect().assign(to: \.currentDateSwiftUI, on: instance)
                }
            })
            .store(in: &disposeBag)
    }

    func enableOnlyUIKitTimer(onlyUIKit: Bool) {
        isUIKitTimerEnabled = onlyUIKit
    }
}
