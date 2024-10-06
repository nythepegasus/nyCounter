import nybits
import Foundation
import SwiftData
import SwiftUI
import AppIntents

struct GetNYCounterIntent: AppIntent {
    static let title: LocalizedStringResource = "Increment NYCounter by Title"

    @Parameter(title: "Counter Title")
    var counterTitle: String

    static var parameterSummary: some ParameterSummary {
        Summary("Increment counter \(\.$counterTitle)")
    }

    @MainActor
    func perform(context: ModelContext) async throws -> some IntentResult & ReturnsValue<Int> {
        let fetchDescriptor = FetchDescriptor<NYCounter>(
            predicate: #Predicate { $0.title == counterTitle }
        )
        let o = container()
        let counters = try o.mainContext.fetch(fetchDescriptor)
        
        guard let counter = counters.first else {
            throw NSError(domain: "NYCounterNotFound", code: 404, userInfo: nil)
        }

        return .result(value: counter.value)
    }
}