//
//  Counter.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import Foundation
import SwiftUI
import SwiftData

import nybits
import nysuibits

@Model
class NYCounter: Identifiable {
    var id: UUID = UUID()
    var order: Int = -1
    var value: Int = 0
    var goal: Int? = nil
    var title: String = "Counter"
    var step: Int = 1
    var items: [NYCountItem]? = []
    
    init(id: UUID = UUID(), order: Int = 0, value: Int = 0, goal: Int? = nil, title: String = "Counter", step: Int = 1, items: [NYCountItem]? = []) {
        self.id = id
        self.order = order
        self.value = value
        self.goal = goal
        self.title = title
        self.step = step
        self.items = items
    }
    
    func increment() {
        withAnimation {
            value.addingWithoutOverflow(step)
        }
    }
    func decrement() {
        withAnimation {
            value.subtractingWithoutOverflow(step)
        }
    }
}

@Model
class NYCountItem: Identifiable {
    var id: UUID = UUID()
    var counter: NYCounter?
    var value: Int = 0
    var time: Date = Date()
    
    init(id: UUID = UUID(), counter: NYCounter? = nil, value: Int = 0, time: Date = Date()) {
        self.id = id
        self.counter = counter
        self.value = value
        self.time = time
    }
}
