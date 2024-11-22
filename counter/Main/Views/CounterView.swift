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
    @Binding var mode: EditMode
    #else
    @Binding var mode: Bool
    #endif
    
    enum Field {
        case title, value, step, goal
    }
    
    @FocusState var isFocused: Field?
    
    var onDelete: () -> Void = {}
    
    var isEditing: Bool {
        #if os(iOS)
        mode == .active
        #else
        mode
        #endif
    }
    
    func toggleEditing() {
        withAnimation {
#if os(iOS)
            mode = mode == .active ? .inactive : .active
#else
            mode.toggle()
#endif
        }
    }
    
    func tBGColor(_ field: Field) -> Color {
        Color.accentColor.opacity(isFocused != field ? 0.6 : 0.9)
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
                    .focused($isFocused, equals: .goal)
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                    .background(tBGColor(.goal))
                TextField("Step Count", value: $counter.step, format: .number)
                    .focused($isFocused, equals: .step)
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                    .background(tBGColor(.step))
                HStack {
                    Button(action: {
                        withAnimation {
                            counter.step.subtractingWithoutOverflow(1)
                            modelContext.insertSave(counter)
                        }
                    }, label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(minWidth: 10, maxWidth: 30, minHeight: 10, maxHeight: 30)
                            .scaledToFit()
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
                            .frame(minWidth: 20, maxWidth: 40, minHeight: 20, maxHeight: 40)
                            .scaledToFit()
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
                        .focused($isFocused, equals: .title)
                        .background(tBGColor(.title))
                } else {
                    Text(counter.title)
                }
                VStack {
                    HStack {
                        if isEditing {
                            TextField("Value", value: $counter.value, format: .number)
                                .focused($isFocused, equals: .value)
                                .background(tBGColor(.value))
#if os(iOS)
                                .keyboardType(.numberPad)
#endif

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
                                .frame(minWidth: 10, maxWidth: 30, minHeight: 10, maxHeight: 30)
                                .scaledToFit()
                        })
                        Spacer()
                            .frame(width: 45)
                        Button(action: {
                            counter.increment()
                            insertNewItem(counter)
                        }, label: {
                            Image(systemName: "plus.square")
                                .resizable()
                                .frame(minWidth: 20, maxWidth: 40, minHeight: 20, maxHeight: 40)
                                .scaledToFit()
                        })
                    }
                    .frame(minHeight: 45)
                }
            }
        }
        .frame(maxWidth: 120)
        .onSubmit {
            isFocused = nil
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
