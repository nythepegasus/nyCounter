//
//  counterApp.swift
//  counter
//
//  Created by ny on 10/3/24.
//

import SwiftUI
import SwiftData
import Observation
@preconcurrency import AppIntents

import nybits
import nydefaults
import nysuibits

struct counterAppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SetNYCounterIntent(),
            phrases: [
                "Set \(.applicationName)",
                "Set \(\.$counter)",
                "Set counter",
        ],
            shortTitle: "Set Counter",
            systemImageName: "equal")
        AppShortcut(
            intent: GetNYCounterIntent(),
            phrases: [
                "Get \(.applicationName)",
                "Get \(\.$counter)",
                "Get counter",
        ],
            shortTitle: "Get Counter",
            systemImageName: "equal.circle")
        AppShortcut(
            intent: IncrementNYCounterIntent(),
            phrases: [
                "Increment \(.applicationName)",
                "Increment \(\.$counter)",
                "Increment counter",
        ],
            shortTitle: "Increment Counter",
            systemImageName: "plus.circle")
        AppShortcut(
            intent: DecrementNYCounterIntent(),
            phrases: [
                "Decrement \(.applicationName)",
                "Decrement \(\.$counter)",
                "Decrement counter",
        ],
            shortTitle: "Decrement Counter",
            systemImageName: "minus.circle")
    }
}

@main
struct counterApp: App {

    
    var countModel: NYCounterModel = .shared
    let depManager: AppIntents.AppDependencyManager = .shared
    
    init() {
        depManager.shim3(key: "NYCounterModel", dependency: NYCounterModel.shared)
        counterAppShortcuts.updateAppShortcutParameters()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterListView()
                .environment(countModel)
        }
        .modelContainer(countModel.container)
    }
    
}

private extension AppDependencyManager {
    
    // Shim using exact declaration as ``AppDependencyManager.add``
    func shim1<Dependency>(key: AnyHashable? = nil, dependency provider: @escaping () -> Dependency) where Dependency : Sendable {
        add(key: key, dependency: provider())
    }
    
    // Shim using exact declaration as ``AppDependencyManager.add``, except that `dependencyProvider` is marked as `Sendable`
    func shim2<Dependency>(key: AnyHashable? = nil, dependency provider: @Sendable @autoclosure @escaping () -> Dependency) where Dependency : Sendable {
        add(key: key, dependency: provider())
    }
    
    // Shim without using an autoclosure
    func shim3<Dependency>(key: AnyHashable? = nil, dependency: Dependency) where Dependency : Sendable {
        add(key: key, dependency: dependency)
    }
    
}
