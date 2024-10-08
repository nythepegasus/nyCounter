//
//  NYAppShortcuts.swift
//  nyCounter
//
//  Created by ny on 10/8/24.
//

import AppIntents

struct NYAppShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: SetNYCounterIntent(),
            phrases: [
                "Set \(\.$counter) from \(.applicationName)",
        ],
            shortTitle: "Set Counter",
            systemImageName: "equal")
        AppShortcut(
            intent: GetNYCounterIntent(),
            phrases: [
                "Get \(\.$counter) from \(.applicationName)",
        ],
            shortTitle: "Get Counter",
            systemImageName: "equal.circle")
    }
}
