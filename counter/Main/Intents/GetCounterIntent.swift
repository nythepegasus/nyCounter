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

struct GetNYCounterIntent: AppIntent {
    static let title: LocalizedStringResource = "Get NYCounter by Title"

    @Parameter(title: "Counter Title")
    var counter: NYCounterEntity

    static var parameterSummary: some ParameterSummary {
        Summary("Get \(\.$counter)'s value")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        guard let counter = NYCounterModel.shared.counters.filter({ $0.id == counter.id }).first else {
            throw NSError(domain: "NYCounterNotFound", code: 404, userInfo: nil)
        }

        return .result(value: counter.value)
    }
}
