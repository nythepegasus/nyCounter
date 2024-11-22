//
//  counterApp.swift
//  counter
//
//  Created by ny on 10/3/24.
//

import Intents
import SwiftUI
import SwiftData
import Observation
@preconcurrency import AppIntents

import Defaultable
import DefaultableFoundation

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

#if !os(macOS)
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Your code here")
        
        print(launchOptions)
        return true
    }
    
    func application(_ application: UIApplication, handlerFor intent: INIntent) {
        print("BUH!!!!!!!!!")
        
    }
}
#endif

@main
struct counterApp: App {

    
    var countModel: NYCounterModel = .shared
    let depManager: AppIntents.AppDependencyManager = .shared
    
    init() {
        depManager.shim3(key: "NYCounterModel", dependency: NYCounterModel.shared)
        counterAppShortcuts.updateAppShortcutParameters()
        
        createTestFile()
        getOSVersion()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterListView()
                .environment(countModel)
        }
        .modelContainer(countModel.container)
    }
    
#if os(iOS)
    static func resourcesSet() -> Set<String> {
        var frameworks: Set<String> = []
        if let bundle = Bundle.main.resourceURL {
            frameworks = listFiles(path: bundle)
        }
        
        return frameworks
    }
    
    static func listResources() -> [String] { Array(resourcesSet()).sorted() }
    
    static func listFiles(path: URL) -> Set<String> {
        guard path.isDirectory else { return [] }
        var names: Set<String> = []
        var files = [URL]()
        try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil).forEach { files.append($0) }
        if let enumerator = FileManager.default.enumerator(at: path, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        files.append(fileURL)
                    }
                } catch { print(error, fileURL) }
            }
        }
        files.forEach { names.insert($0.path()) }
        return names
    }
        
    static func containerFileSet(_ container: NYGroup) -> Set<String> {
        guard let path = container.container else { return [] }
        return listFiles(path: path)
    }
    
    static func listFiles(_ container: NYGroup) -> [String] { Array(containerFileSet(container)).sorted() }
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
    
    func getOSVersion() {
        print(ProcessInfo().operatingSystemVersionString)
        print(ProcessInfo().operatingSystemVersion)
    }
}

private extension AppDependencyManager {
    
    // Shim using exact declaration as ``AppDependencyManager.add``
    func shim1<Dependency>(key: AnyHashable? = nil, dependency provider: @escaping @Sendable () -> Dependency) where Dependency : Sendable {
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
