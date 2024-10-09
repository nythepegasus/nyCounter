//
//  IncrementCounter.swift
//  nyCounter
//
//  Created by ny on 10/5/24.
//

import nybits
import Foundation
import SwiftData
import SwiftUI
import AppIntents

struct DecrementNYCounterIntent: AppIntent {
    static let title: LocalizedStringResource = "Decrement NYCounter by Title"

    @Parameter(title: "Counter Title")
    var counter: NYCounterEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Decrement \(\.$counter)")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        guard let counter = NYCounterModel.shared.counters.filter({ $0.id == counter.id }).first else {
            throw NSError(domain: "NYCounterNotFound", code: 404, userInfo: nil)
        }

        counter.decrement()
        counter.insertSave(NYCounterModel.shared.container.mainContext)

        return .result(value: counter.value)
    }
}
