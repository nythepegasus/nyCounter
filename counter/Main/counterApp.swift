//
//  counterApp.swift
//  counter
//
//  Created by ny on 10/3/24.
//

import SwiftUI
import SwiftData
import Observation
import AppIntents

import nybits
import nydefaults
import nysuibits

@main
struct counterApp: App {
    var countModel: NYCounterModel = .shared
    let depManager: AppIntents.AppDependencyManager = .shared
    
    init() {
        depManager.shim3(key: "NYCounterModel", dependency: NYCounterModel.shared)
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
