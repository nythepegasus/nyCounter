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

struct SetNYCounterIntent: AppIntent {
    static let title: LocalizedStringResource = "Set NYCounter by Title"
    
    @Dependency(key: "NYCounterModel")
    var model: NYCounterModel

    @Parameter(title: "Counter")
    var counter: NYCounterEntity
    
    @Parameter(title: "Counter Value")
    var counterValue: Int
    
    @Parameter(title: "Return Old Value", default: false)
    var returnOld: Bool
    
    static var parameterSummary: some ParameterSummary {
        Summary("Set \(\.$counter) to \(\.$counterValue) and returns old \(\.$returnOld).")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<Int> {
        guard let counter = model.counters.filter({ $0.id == counter.id }).first else {
            throw NSError(domain: "NYCounterNotFound", code: 404, userInfo: nil)
        }

        let value = returnOld ? counter.value : counterValue
        
        counter.set(value: counterValue)
        counter.insertSave(model.container.mainContext)

        return .result(value: value)
    }
}
