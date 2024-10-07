//
//  Helpers-Utilities.swift
//  StoiximanGR
//
//  Created by Dionisis Chatzimarkakis on 7/10/24.
//

import Combine

typealias DisposeBagForCombine = Set<AnyCancellable>
extension DisposeBagForCombine {
    mutating func dispose() {
        forEach { $0.cancel() }
        removeAll()
    }
}
