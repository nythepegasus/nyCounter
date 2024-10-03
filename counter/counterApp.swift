//
//  counterApp.swift
//  counter
//
//  Created by ny on 10/3/24.
//

import SwiftUI
import SwiftData

@main
struct counterApp: App {
    var sharedModelContainer: ModelContainer = container()
    
    
    var body: some Scene {
        WindowGroup {
            CounterListView()
        }
        .modelContainer(sharedModelContainer)
    }
}

func container() -> ModelContainer {
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
}
