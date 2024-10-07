//
//  BaseUrl.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 7/10/24.
//

import Foundation

struct Config {
    static var baseURL: String {
        // Access the BaseURL from Info.plist
        if let baseURL = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String {
            return baseURL
        } else {
            fatalError("BaseURL not found in Info.plist")
        }
    }
}
