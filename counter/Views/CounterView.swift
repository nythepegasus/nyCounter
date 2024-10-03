//
//  SwiftUIView.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import SwiftUI

struct NYCounterView: View {
    @Environment(\.modelContext) private var modelContext
    @State var counter: NYCounter
    @Binding var editMode: EditMode
    var onDelete: () -> Void = {}
    
    var body: some View {
        VStack {
            if editMode == .active {
                HStack {
                    Spacer()
                    Button(action: onDelete, label: {
                        Image(systemName: "trash")
                    })
                }
            }
            VStack {
                if editMode == .active {
                    TextField("Counter Title", text: $counter.title)
                } else {
                    Text(counter.title)
                }
                HStack {
                    Button(action: {
                        counter.value -= counter.step
                        let item = NYCountItem(counter: counter, value: counter.value)
                        counter.items?.append(item)
                        modelContext.insert(item)
                    }, label: {
                        Image(systemName: "minus.square")
                    })
                    Text("\(counter.value)")
                    Button(action: {
                        counter.value += counter.step
                        let item = NYCountItem(counter: counter, value: counter.value)
                        counter.items?.append(item)
                        modelContext.insert(item)
                    }, label: {
                        Image(systemName: "plus.square")
                    })
                }
            }
        }
    }
}

#Preview {
    NYCounterView(counter: NYCounter(title: "Woah!"), editMode: .constant(.inactive))
}
