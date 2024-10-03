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
    #if os(iOS)
    @Binding var editMode: EditMode
    #else
    @Binding var editMode: Bool
    #endif
    var onDelete: () -> Void = {}
    
    var body: some View {
        VStack {
            #if os(iOS)
            if editMode == .active {
                HStack {
                    Spacer()
                    Button(action: onDelete, label: {
                        Image(systemName: "trash")
                    })
                }
            }
            #else
            if editMode {
                HStack {
                    Spacer()
                    Button(action: onDelete, label: {
                        Image(systemName: "trash")
                    })
                }
            }
#endif
            VStack {
                #if os(iOS)
                if editMode == .active {
                    TextField("Counter Title", text: $counter.title)
                } else {
                    Text(counter.title)
                }
                #else
                if editMode {
                    TextField("Counter Title", text: $counter.title)
                } else {
                    Text(counter.title)
                }
                #endif
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
    NYCounterView(counter: NYCounter(title: "Woah!"), editMode: .constant(false))
}
