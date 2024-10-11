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
        NavigationView {
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
                
                
                #if DEBUG
                Section {
                    NavigationLink("App Groups", destination: StringListView(title: "App Groups", strings: NYGroup.allCases.map { $0.name }))
                    NavigationLink("Resources", destination: StringListView(title: "Resources", strings: counterApp.listResources()))
                    NavigationLink("Frameworks", destination: StringListView(title: "Frameworks", strings: counterApp.listFrameworks()))
                    NavigationLink("ny.apps Files", destination: StringListView(title: "ny Files", strings: counterApp.listFiles(.ny)))
                    NavigationLink("SideStore Files", destination: StringListView(title: "SideStore Files", strings: counterApp.listFiles(.sidestore)))
                    NavigationLink("LongName Files", destination: StringListView(title: "LongName Files", strings: counterApp.listFiles(.longname)))
                }
                #endif
            }
            .navigationTitle("Settings")
        }
        Spacer()
        Text(verbatim: Bundle.main.shortVersion)
        Text(verbatim: Bundle.main.identifier)
        Text(verbatim: Bundle.main.copyright)
    }
}

// View to display a list of strings
struct StringListView: View {
    let title: String
    let strings: [String]
    
    var body: some View {
        List(strings, id: \.self) { string in
            Text(string)
        }
        .navigationTitle(title)
    }
}

#Preview {
    NCSettingsView()
        .environment(NYCounterModel())
}
