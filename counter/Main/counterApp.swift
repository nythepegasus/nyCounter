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

import libusbmuxd
import libplist

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

enum NYGroup: String, CaseIterable, AppGroupID {
    case ny = "group.ny.apps"
    case sidestore = "group.com.SideStore.SideStore"
    case longname = "group.com.reallylongnameofanappthatdoesntexist.atallwowthisisareallylongname"
}

@main
struct counterApp: App {

    
    var countModel: NYCounterModel = .shared
    let depManager: AppIntents.AppDependencyManager = .shared
    
    init() {
        depManager.shim3(key: "NYCounterModel", dependency: NYCounterModel.shared)
        counterAppShortcuts.updateAppShortcutParameters()
        
        createTestFile()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterListView()
                .environment(countModel)
        }
        .modelContainer(countModel.container)
    }
    
#if os(iOS)
    static func listResources() -> [String] {
        var frameworks: [String] = []
        if let bundle = Bundle.main.resourceURL {
            frameworks = listFiles(path: bundle)
        }
        
        return frameworks
    }
    
    static func listFrameworks() -> [String] {
        var frameworks: [String] = []
        if let bundle = Bundle.main.resourceURL {
            frameworks = listFiles(path: bundle.appending(path: "Frameworks/"))
        }
        
        return frameworks
    }
    
    static func listFiles(path: URL) -> [String] {
        return (try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil).map { String($0.path) })~
    }
    
    static func listFiles(_ container: NYGroup) -> [String] {
        guard let path = container.container else { return [] }
        switch container {
        case .ny: return listFiles(path: path) + listFiles(path: path.appending(path: "Library/")) + listFiles(path: path.appending(path: "Library/Application Support"))
        case .longname: return listFiles(path: path) + listFiles(path: path.appending(path: "Library/"))
        case .sidestore: return listFiles(path: path) + listFiles(path: path.appending(path: "Apps/")) + listFiles(path: path.appending(path: "Library/"))
        }
    }
#endif
    
    @discardableResult
    func createTestFile() -> Bool {
        
#if os(iOS)
        let na = NYGroup.ny
        let ss = NYGroup.sidestore
        let ln = NYGroup.longname
        print("CONTAINER: \(na.container~.path) - \(na.rawValue)")
        print("CONTAINER: \(ss.container~.path) - \(ss.rawValue)")
    print("CONTAINER: \(ln.container~.path) - \(ln.rawValue)")
#endif
        return true
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
