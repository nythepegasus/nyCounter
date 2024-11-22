//
//  IncrementCounter.swift
//  nyCounter
//
//  Created by ny on 10/5/24.
//

import Foundation
import SwiftData
import SwiftUI
import AppIntents

struct IncrementNYCounterIntent: AppIntent {
    static let title: LocalizedStringResource = "Increment NYCounter by Title"
    
    @Dependency(key: "NYCounterModel")
    var model: NYCounterModel
    
    @Parameter(title: "Counter Title")
    var counter: NYCounterEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Increment \(\.$counter)")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        guard let counter = model.counters.filter({ $0.id == counter.id }).first else {
            throw NSError(domain: "NYCounterNotFound", code: 404, userInfo: nil)
        }

        counter.increment()
        counter.insertSave(model.container.mainContext)

        return .result(value: counter.value)
    }
}
