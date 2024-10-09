//
//  SettingsView.swift
//  nyCounter
//
//  Created by ny on 10/7/24.
//

import SwiftUI
import nybits
import nysuibits
import nybundle


struct NCSettingsView: View {
    @AppStorage("vertical")
    var vertical: Bool = false
    
    @Environment(NYCounterModel.self) private var countModel

    @State
    var showIConfirmation: Bool = false
    @State
    var showCConfirmation: Bool = false

    var body: some View {
        Form {
            Toggle("Vertical Scrolling", isOn: $vertical)
            Button("Delete All Counted Items", systemImage: "document", role: .destructive) {
                showIConfirmation = true
            }
            .confirmationDialog("Are you certain you want to delete all items related to counters?", isPresented: $showIConfirmation) {
                Button("Delete All Items", role: .destructive) {
                    showIConfirmation = false
                    countModel.countItems.forEach { countModel.delete($0) }
                }
            } message: {
                Text("This will delete all counted items.")
            }
            Button("Delete All Counters", systemImage: "archivebox", role: .destructive) {
                showCConfirmation = true
            }
            .confirmationDialog("Are you certain you want to delete all counters?", isPresented: $showCConfirmation) {
                Button("Delete All Counters", role: .destructive) {
                    showCConfirmation = false
                    countModel.counters.forEach { countModel.delete($0) }
                }
            } message: {
                Text("This will delete all counters and their items.")
            }
        }
        Spacer()
        Text(verbatim: Bundle.main.infoDictionary?["CFBundleShortVersionString"] ??? String.self)
    }
}

#Preview {
    NCSettingsView()
}
