//
//  SettingsView.swift
//  nyCounter
//
//  Created by ny on 10/7/24.
//

import SwiftUI
import UIKit

struct NCSettingsView: View {
    @AppStorage("username") private var username = "User"
    @AppStorage("customBackgroundColor") private var customBackgroundColorHex: String = "#000000"
    @AppStorage("customAccentColor") private var customAccentColorHex: String = "#796CFF"
    @AppStorage("vertical") var vertical: Bool = false

    
    @Environment(NYCounterModel.self) private var countModel
    
    @State private var selectedBackgroundColor: Color = .teal
    @State private var selectedAccentColor: Color = .purple
    
    @State private var showIConfirmation: Bool = false
    @State private var showCConfirmation: Bool = false
    
#if DEBUG
    @State private var showDebugSection: Bool = true
#else
    @State private var showDebugSection: Bool = false
#endif
    
    var body: some View {
        ZStack {
            // Background Color
            selectedBackgroundColor
                .ignoresSafeArea()
            
            NavigationView {
                Form {
                    // General Section
                    Section(header: Text("General").foregroundColor(selectedAccentColor)) {
                        HStack {
                            Label("", systemImage: "person.fill")
                                .foregroundColor(selectedAccentColor)
                            Spacer()
                            TextField("Username", text: $username)
                                .foregroundColor(selectedAccentColor)
                                .padding(10)
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(selectedBackgroundColor, lineWidth: 1)
                                )
                        }
                        
                        Toggle("Vertical Scrolling", isOn: $vertical)
                    }
                    
                    // Appearance Section
                    Section(header: Text("Appearance").foregroundColor(selectedAccentColor)) {
                        ColorPicker("Background Color", selection: $selectedBackgroundColor)
                            .onChange(of: selectedBackgroundColor) { newColor in
                                saveCustomBackgroundColor(newColor)
                            }
                        
                        ColorPicker("Accent Color", selection: $selectedAccentColor)
                            .onChange(of: selectedAccentColor) { newColor in
                                saveCustomAccentColor(newColor)
                            }
                    }
                    
                    // Actions Section
                    Section(header: Text("Actions").foregroundColor(selectedAccentColor)) {
                        Button("Delete All Counted Items", systemImage: "trash", role: .destructive) {
                            showIConfirmation = true
                        }
                        .confirmationDialog("Are you sure you want to delete all counted items?", isPresented: $showIConfirmation) {
                            Button("Delete", role: .destructive) {
                                countModel.countItems.forEach { countModel.delete($0) }
                            }
                        }
                        
                        Button("Delete All Counters", systemImage: "archivebox", role: .destructive) {
                            showCConfirmation = true
                        }
                        .confirmationDialog("Are you sure you want to delete all counters?", isPresented: $showCConfirmation) {
                            Button("Delete", role: .destructive) {
                                countModel.counters.forEach { countModel.delete($0) }
                            }
                        }
                    }
                    
                    // File Navigation Section (Debug)
#if os(iOS)
                    if showDebugSection {
                        Section(header: Text("Files").foregroundColor(selectedAccentColor)) {
                            NavigationLink("App Group Files") {
                                List(NYGroup.allCases.map { String($0.rawValue) }, id: \.self) { gr in
                                    NavigationLink(gr, destination: StringListView(title: "\(gr) files", strings: counterApp.listFiles(.init(rawValue: gr)!)))
                                }
                            }
                            NavigationLink("Resources", destination: StringListView(title: "App Files", strings: counterApp.listResources()))
                        }
                    }
#endif
                    
                    // Debug Info Section
#if DEBUG
                    if showDebugSection {
                        Section(header: Text("Debug Info").foregroundColor(selectedAccentColor)) {
                            Text("\(Bundle.main.displayName) - \(Bundle.main.shortVersion)")
                                .monospaced()
                            Text(ProcessInfo().operatingSystemBuild)
                                .monospaced()
                        }
                    }
#endif
                }
                // Footer Section
                .scrollContentBackground(.hidden)
                .background(selectedBackgroundColor)
                .navigationTitle("Settings")
                .tint(selectedAccentColor)
                .onAppear {
                    loadCustomBackgroundColor()
                    loadCustomAccentColor()
                }
                .safeAreaInset(edge: .bottom) {
                    Text(Bundle.main.copyright)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
    
    // Load and save methods for background and accent colors
    private func loadCustomBackgroundColor() {
        selectedBackgroundColor = Color(hex: customBackgroundColorHex) ?? .teal
    }
    
    private func saveCustomBackgroundColor(_ color: Color) {
        customBackgroundColorHex = color.toHex() ?? "#008080"
    }
    
    private func loadCustomAccentColor() {
        selectedAccentColor = Color(hex: customAccentColorHex) ?? .purple
    }
    
    private func saveCustomAccentColor(_ color: Color) {
        customAccentColorHex = color.toHex() ?? "#FF0000"
    }
}

// MARK: - Color Extensions
extension Color {
    /// Initialize `Color` from a hex string
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") { hexSanitized.remove(at: hexSanitized.startIndex) }
        
        var rgbValue: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgbValue) else { return nil }
        
        let r = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = Double(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
    
    /// Convert `Color` to hex string
    func toHex() -> String? {
        guard let components = UIColor(self).cgColor.components, components.count >= 3 else { return nil }
        let r = components[0]
        let g = components[1]
        let b = components[2]
        return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
}

// MARK: - String List View
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

extension ProcessInfo {
    /// Extract the OS build version
    var operatingSystemBuild: String {
        if let start = operatingSystemVersionString.range(of: "(")?.upperBound,
           let end = operatingSystemVersionString.range(of: ")")?.lowerBound {
            return String(operatingSystemVersionString[start..<end])
                .replacingOccurrences(of: "Build ", with: "")
        } else {
            return "Unknown Build"
        }
    }
}
