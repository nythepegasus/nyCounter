//
//  Counter.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import nybits
import nydefaults
import Foundation
import SwiftUI
import SwiftData

@Model
class NYCounter: Identifiable {
    var id: UUID = UUID()
    var value: Int = 0
    var goal: Int?
    var title: String = "Counter"
    var step: Int = 1
    var items: [NYCountItem]? = []
    
    init(id: UUID = UUID(), value: Int = 0, goal: Int? = nil, title: String = "Counter", step: Int = 1, items: [NYCountItem]? = []) {
        self.id = id
        self.value = value
        self.goal = goal
        self.title = title
        self.step = step
        self.items = items
    }
    
    func increment() {
        withAnimation {
            value = value.addWithoutOverflow(step)
        }
    }
    func decrement() {
        withAnimation {
            value = value.subtractWithoutOverflow(step)
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

extension PersistentModel {
    func insert(_ context: ModelContext) {
        context.insert(self)
    }
    
    func insertSave(_ context: ModelContext) {
        context.insertSave(self)
    }
    
    func delete(_ context: ModelContext) {
        context.delete(self)
    }
}

extension ModelContext {
    func insertSave<T>(_ model: T) where T: PersistentModel {
        insert(model)
        do {
            try save()
        } catch {
            print("Error saving model: \(error.localizedDescription)")
        }
    }
}
