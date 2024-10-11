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
    
#if DEBUG
    @State
    var showDebugSection: Bool = true
#else
    @State
    var showDebugSection: Bool = false
#endif

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
                
#if os(iOS)
                if showDebugSection {
                    Section {
                    NavigationLink("App Group Files") {
                        List(NYGroup.allCases.map { String($0.rawValue) }, id: \.self) { gr in
                            NavigationLink(gr, destination: StringListView(title: "\(gr) files", strings: counterApp.listFiles(.init(rawValue: gr)!)))
                        }
                    }
                    NavigationLink("Resources", destination: StringListView(title: "App Files", strings: counterApp.listResources()))
                }
            }
#endif
            }
            .navigationTitle("Settings")
        }
#if os(iOS)
        Spacer()
                Group {
                    if showDebugSection {
                        Text(verbatim: "\(Bundle.main.displayName) - \(Bundle.main.identifier)")
                            .monospaced()
                        Text(verbatim: "\(Bundle.main.shortVersion) - \(Bundle.main.version)")
                            .monospaced()
                    } else {
                        Text(verbatim: "\(Bundle.main.displayName) - \(Bundle.main.shortVersion)")
                    }
                    Text(verbatim: Bundle.main.copyright)
                        .monospaced(showDebugSection)
                }
                .onTapGesture(count: 8) {
                    showDebugSection.toggle()
                }
#endif
    }
}

// View to display a list of strings
struct StringListView: View {
    let title: String
    let strings: [String]
    
    var body: some View {
        if strings.count > 0 {
            List(strings, id: \.self) { string in
                Text(string)
            }
            .navigationTitle(title)
        } else {
            List {
                Text("No Files")
            }
            .navigationTitle(title)
        }
    }
}

#Preview {
    NCSettingsView()
        .environment(NYCounterModel())
}
