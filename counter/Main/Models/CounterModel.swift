//
//  CounterModel.swift
//  nyCounter
//
//  Created by ny on 10/8/24.
//

import Foundation
import SwiftData
import AppIntents
import Combine

import nybits
import nydefaults
import nysuibits

@MainActor
class NYCounterModel: ObservableObject, Observable, @unchecked Sendable {
    static let shared = NYCounterModel()
    
    var container: ModelContainer

    var counters: [NYCounter] = []
    
    @Published
    var counterEntities: [NYCounterEntity] = []
    
    private var ccancellable: AnyCancellable?
    
    var countItems: [NYCountItem] = []
    
    @Published
    var countItemEntities: [NYCountItemEntity] = []
    
    private var icancellable: AnyCancellable?

    init() {
        // Initialize the model container
        self.container = {
            let schema = Schema([
                NYCounter.self,
                NYCountItem.self,
            ])
            let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                fatalError("Could not create ModelContainer: \(error)")
            }
        }()
        
        // Initialize cancellables to listen to changes in Published properties
        self.ccancellable = $counterEntities.sink { _ in
            counterAppShortcuts.updateAppShortcutParameters()
        }
        self.icancellable = self.$countItemEntities.sink { _ in
            counterAppShortcuts.updateAppShortcutParameters()
        }
    }
    
    // Fetch counters asynchronously
    func fetchCounters() async throws {
        do {
            self.counters = try container.mainContext.fetch(FetchDescriptor<NYCounter>())
        } catch {
            self.counters = []
        }
    }
    
    // Fetch count items asynchronously
    func fetchCountItems() async throws {
        do {
            self.countItems = try container.mainContext.fetch(FetchDescriptor<NYCountItem>())
        } catch {
            self.countItems = []
        }
    }

    // Generic delete function
    func delete<T>(_ model: T) where T : PersistentModel {
        container.mainContext.delete(model)
    }
    
    // Computed property to get the highest order value
    var highestOrder: Int {
        Task {
            try? await fetchCounters()
        }
        return counters.map { $0.order }.max()~ + 1
    }
}

extension NYCounterModel {
    // Retrieve a counter by its ID
    func counter(with id: NYCounter.ID) -> NYCounter? {
        counters.first { $0.id == id }
    }
    
    // Retrieve multiple counters by their IDs
    func counters(with ids: [NYCounter.ID]) -> [NYCounter] {
        counters.compactMap { counter in
            ids.contains(counter.id) ? counter : nil
        }
    }
    
    // Retrieve counters matching a specific predicate
    func counters(matching predicate: (NYCounter) -> Bool) -> [NYCounter] {
        counters.filter(predicate)
    }
}
