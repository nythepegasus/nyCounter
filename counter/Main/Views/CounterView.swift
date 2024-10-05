//
//  SwiftUIView.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import nybits
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
    
    var stepEditor: some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        onDelete()
                        try? modelContext.save()
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
                            counter.step = counter.step.subtractWithoutOverflow(1)
                            modelContext.insertSave(counter)
                        }
                    }, label: {
                        Image(systemName: "minus.circle")
#if os(iOS)
                            .resizable()
                            .frame(width: 30, height: 30)
#endif
                    })
                    Spacer()
                        .frame(width: 45)
                    Button(action: {
                        withAnimation {
                            counter.step = counter.step.addWithoutOverflow(1)
                            modelContext.insertSave(counter)
                        }
                    }, label: {
                        Image(systemName: "plus.circle")
#if os(iOS)
                            .resizable()
                            .scaledToFit()
#endif
                    })
                }
            }
        }
        .frame(width: 120)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            #if os(iOS)
            if editMode == .active {
                stepEditor
            }
            #else
            if editMode {
                stepEditor
            }
#endif
            VStack {
#if os(iOS)
                if editMode == .active {
                    TextField("Counter Title", text: $counter.title)
                        .background(Color.accentColor.opacity(0.6))
                } else {
                    Text(counter.title)
                }
#else
                if editMode {
                    TextField("Counter Title", text: $counter.title)
                        .background(Color.accentColor.opacity(0.6))
                } else {
                    Text(counter.title)
                }
#endif
                VStack {
                    HStack {
#if os(iOS)
                        if editMode == .active {
                            TextField("Value", value: $counter.value, format: .number)
                                .keyboardType(.numberPad)
                                .background(Color.accentColor.opacity(0.6))
                        } else {
                            Text("\(counter.value)")
                        }
#else
                        if editMode {
                            TextField("Value", value: $counter.value, format: .number)
                                .background(Color.accentColor.opacity(0.6))

                        } else {
                            Text("\(counter.value)")
                        }
#endif
                    }
                    HStack {
                        Button(action: {
                            withAnimation {
                                counter.value = counter.value.subtractWithoutOverflow(counter.step)
                                insertNewItem(counter)
                            }
                        }, label: {
                            Image(systemName: "minus.square")
#if os(iOS)
                                .resizable()
                                .frame(width: 30, height: 30)
#endif
                        })
                        Spacer()
                            .frame(width: 45)
                        Button(action: {
                            withAnimation {
                                counter.value = counter.value.addWithoutOverflow(counter.step)
                                insertNewItem(counter)
                            }
                        }, label: {
                            Image(systemName: "plus.square")
#if os(iOS)
                                .resizable()
                                .scaledToFit()
#endif
                        })
                    }
                }
            }
        }
        .frame(width: 120)
        .onChange(of: counter.goal) {
            modelContext.insertSave(counter)
        }
        .onChange(of: counter.title) {
            modelContext.insertSave(counter)
        }
        .onChange(of: counter.step) {
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
    NYCounterView(counter: NYCounter(title: "Woah!"), editMode: .constant(.inactive))
    #else
    NYCounterView(counter: NYCounter(title: "Woah!"), editMode: .constant(false))
    #endif
}
