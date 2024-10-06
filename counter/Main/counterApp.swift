//
//  counterApp.swift
//  counter
//
//  Created by ny on 10/3/24.
//

import SwiftUI
import SwiftData
import Observation
import nybits
import nydefaults

@main
struct counterApp: App {
    var countModel: NYCounterModel = .shared
    
    var body: some Scene {
        WindowGroup {
            CounterListView()
                .environment(countModel)
        }
        .modelContainer(countModel.container)
    }
}

@MainActor
@Observable
class NYCounterModel: ObservableObject, @unchecked Sendable {
    static let shared = NYCounterModel()
    
    var container: ModelContainer

    var counters: [NYCounter]
    var countItems: [NYCountItem]
    
    init() {
        self.counters = []
        self.countItems = []
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
    }
    
    func fetchCounters() async throws {
        do {
            self.counters = try container.mainContext.fetch(FetchDescriptor<NYCounter>())
        } catch {
            self.counters = []
        }
    }
    
    func fetchCountItems() async throws {
        do {
            self.countItems = try container.mainContext.fetch(FetchDescriptor<NYCountItem>())
        } catch {
            self.countItems = []
        }
    }
    
    var highestOrder: Int {
        Task {
            try? await fetchCounters()
        }
        return counters.map { $0.order }.max()~ + 1
    }
}

extension NYCounterModel {
    func counter(with id: NYCounter.ID) -> NYCounter? {
        counters.first { $0.id == id }
    }
    
    func counters(with ids: [NYCounter.ID]) -> [NYCounter] {
        counters.compactMap { counter in
            ids.contains(counter.id) ? counter : nil
        }
    }
    
    func counters(matching predicate: (NYCounter) -> Bool) -> [NYCounter] {
        counters.filter(predicate)
    }
}
