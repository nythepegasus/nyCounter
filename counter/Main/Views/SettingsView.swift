//
//  SettingsView.swift
//  nyCounter
//
//  Created by ny on 10/7/24.
//

import SwiftUI
import nybits
import nysuibits


struct NCSettingsView: View {
    @AppStorage("vertical")
    var vertical: Bool = false
    
    var body: some View {
        Form {
            Toggle("Vertical Scrolling", isOn: $vertical)
        }
    }
}

#Preview {
    NCSettingsView()
}
