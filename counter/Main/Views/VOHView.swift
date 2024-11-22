//
//  VOHView.swift
//  nyCounter
//
//  Created by ny on 10/7/24.
//

import SwiftUI


struct VOHView<Content: View>: View {
    @Environment(\.accessibilityShowButtonShapes)
    private var accessibilityShowButtonShapes
    
    let content: Content
    
    var items: [GridItem] = [
        GridItem(.adaptive(minimum: 200, maximum: .infinity))
    ]
    
    var vitems: [GridItem] = [
        GridItem(.adaptive(minimum: 200, maximum: .infinity)),
        GridItem(.adaptive(minimum: 200, maximum: .infinity))
    ]

    @AppStorage("vertical")
    private var vertical: Bool = false
    
    init(items: [GridItem]? = nil, @ViewBuilder content: () -> Content) {
        self.content = content()
        if let items {
            self.items = items
        }
    }
    
    var body: some View {
        if vertical {
            ScrollView(.vertical) {
                LazyVGrid(columns: vitems, alignment: .center) {
                    content
                }
            }
        } else {
            ScrollView(.horizontal) {
                Spacer()
                LazyHGrid(rows: items, alignment: .center) {
                    content
                }
            }
        }
    }
}

#Preview {
    VOHView {
        Text("Buh")
    }
}
