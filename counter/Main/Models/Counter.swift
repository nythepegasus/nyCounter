//
//  Counter.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import Foundation
import SwiftUI
import SwiftData
import AppIntents

import nybits
import nysuibits

@Model
final class NYCounter: @unchecked Sendable, Identifiable {
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
    
    func set(value: Int) {
        withAnimation {
            self.value = value
        }
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

struct NYCounterEntity: AppEntity {
    
    static let defaultQuery: NYCounterQuery = .init()
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        .init(stringLiteral: "Counter")
    }
    
    var displayRepresentation: DisplayRepresentation {
        .init(stringLiteral: "\(title)")
    }
    
    var id: UUID = UUID()
    var title: String
    
    init(counter: NYCounter) {
        self.id = counter.id
        self.title = counter.title
    }
}

struct NYCounterQuery: EntityQuery {
    
    @Dependency(key: "NYCounterModel")
    var countModel: NYCounterModel
    
    func entities(for identifiers: [NYCounterEntity.ID]) async throws -> [NYCounterEntity] {
        return await countModel.counters.filter { identifiers.contains($0.id) }.map { NYCounterEntity(counter: $0) }
    }
    
    func suggestedEntities() async throws -> [NYCounterEntity] {
        return await countModel.counters.map { NYCounterEntity(counter: $0) }
    }
}

@Model
final class NYCountItem: @unchecked Sendable, Identifiable {
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

struct NYCountItemEntity: AppEntity {
    
    static let defaultQuery: NYCountItemQuery = .init()
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        .init(stringLiteral: "Item")
    }
    
    var displayRepresentation: DisplayRepresentation {
        .init(stringLiteral: "\(title)")
    }
    
    var id: UUID = UUID()
    var title: String
    
    init(item: NYCountItem) {
        self.id = item.id
        self.title = item.counter?.title ?? ""
    }
}

struct NYCountItemQuery: EntityQuery {
    
    @Dependency(key: "NYCounterModel")
    var countModel: NYCounterModel
    
    func entities(for identifiers: [NYCountItemEntity.ID]) async throws -> [NYCountItemEntity] {
        return await countModel.countItems.filter { identifiers.contains($0.id) }.map { NYCountItemEntity(item: $0) }
    }
    
    func suggestedEntities() async throws -> [NYCountItemEntity] {
        return await countModel.countItems.map { NYCountItemEntity(item: $0) }
    }
}
