//
//  SwiftUIView.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import SwiftUI

import nysuibits

struct NYCounterView: View {
    @Environment(\.modelContext) private var modelContext
    @State var counter: NYCounter
    #if os(iOS)
    @Binding var mode: EditMode
    #else
    @Binding var mode: Bool
    #endif
    var onDelete: () -> Void = {}
    
    var isEditing: Bool {
        #if os(iOS)
        mode == .active
        #else
        mode
        #endif
    }
    
    func toggleEditing() {
        #if os(iOS)
        mode = mode == .active ? .inactive : .active
        #else
        mode.toggle()
        #endif
    }
    
    var stepEditor: some View {
        VStack(alignment: .center) {
            HStack {
                Button(action: {
                    withAnimation {
                        onDelete()
                        modelContext.Save("Error deleting \(counter.title).")
                    }
                }, label: {
                    Image(systemName: "trash")
                })
            }
            Divider()
            VStack(alignment: .center) {
                TextField("Goal", value: $counter.goal, format: .number)
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                    .background(Color.accentColor.opacity(0.6))
                TextField("Step Count", value: $counter.step, format: .number)
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                    .background(Color.accentColor.opacity(0.6))
                HStack {
                    Button(action: {
                        withAnimation {
                            counter.step.subtractingWithoutOverflow(1)
                            modelContext.insertSave(counter)
                        }
                    }, label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                    })
                    Spacer()
                        .frame(width: 45)
                    Button(action: {
                        withAnimation {
                            counter.step.addingWithoutOverflow(1)
                            modelContext.insertSave(counter)
                        }
                    }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                    })
                }
                .frame(minHeight: 45)
            }
        }
        .frame(width: 120)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if isEditing {
                stepEditor
            }
            VStack {
                if isEditing {
                    TextField("Counter Title", text: $counter.title)
                        .background(Color.accentColor.opacity(0.6))
                } else {
                    Text(counter.title)
                }
                VStack {
                    HStack {
                        if isEditing {
                            TextField("Value", value: $counter.value, format: .number)
#if os(iOS)
                                .keyboardType(.numberPad)
#endif
                                .background(Color.accentColor.opacity(0.6))

                        } else {
                            Text("\(counter.value)")
                        }
                    }
                    HStack {
                        Button(action: {
                            counter.decrement()
                            insertNewItem(counter)
                        }, label: {
                            Image(systemName: "minus.square")
                                .resizable()
                                .frame(width: 30, height: 30)
                        })
                        Spacer()
                            .frame(width: 45)
                        Button(action: {
                            counter.increment()
                            insertNewItem(counter)
                        }, label: {
                            Image(systemName: "plus.square")
                                .resizable()
                                .frame(width: 40, height: 40)
                        })
                    }
                    .frame(minHeight: 45)
                }
            }
        }
        .frame(width: 120)
        .onChange([counter.step, counter.goal]) {
            modelContext.insertSave(counter)
        }
        .onChange(of: counter.title) {
            modelContext.insertSave(counter)
        }
        .onSubmit {
            modelContext.insertSave(counter)
        }
    }
    
    func insertNewItem(_ counter: NYCounter) {
        NYCountItem(counter: counter, value: counter.value).insertSave(modelContext)
        modelContext.insertSave(counter)
    }
}

#Preview {
    #if os(iOS)
    NYCounterView(counter: NYCounter(title: "Woah!"), mode: .constant(.inactive))
    #else
    NYCounterView(counter: NYCounter(title: "Woah!"), mode: .constant(false))
    #endif
}
