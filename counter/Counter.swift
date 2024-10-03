//
//  Counter.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import nybits
import nydefaults
import Foundation
import SwiftData

@Model
class NYCounter: Identifiable {
    var id: UUID = UUID()
    var value: Int = 0
    var title: String = "Counter"
    var step: Int = 1
    var items: [NYCountItem]? = []
    
    init(id: UUID = UUID(), value: Int = 0, title: String = "Counter", step: Int = 1, items: [NYCountItem]? = []) {
        self.id = id
        self.value = value
        self.title = title
        self.step = step
        self.items = items
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
