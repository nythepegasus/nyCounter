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

    @AppStorage("customAccentColor") private var customAccentColorHex: String = "#796CFF"
    private var customAccentColor: Color {
        Color(hex: customAccentColorHex) ?? .purple
    }
    
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
    
    func tBGColor(_ field: Field) -> Color {
        customAccentColor.opacity(isFocused != field ? 0.6 : 0.9)
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
                        .foregroundColor(customAccentColor)
                })
            }
            Divider()
            VStack(alignment: .center) {
                TextField("Goal", value: $counter.goal, format: .number)
                    .focused($isFocused, equals: .goal)
                    .foregroundColor(.white)
                    .background(tBGColor(.goal))
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                TextField("Step Count", value: $counter.step, format: .number)
                    .focused($isFocused, equals: .step)
                    .foregroundColor(.white)
                    .background(tBGColor(.step))
#if os(iOS)
                    .keyboardType(.numberPad)
#endif
                HStack {
                    Button(action: {
                        withAnimation {
                            counter.step.subtractingWithoutOverflow(1)
                            modelContext.insertSave(counter)
                        }
                    }, label: {
                        Image(systemName: "minus.circle")
                            .resizable()
                            .foregroundColor(customAccentColor)
                            .frame(width: 30, height: 30)
                    })
                    Spacer().frame(width: 45)
                    Button(action: {
                        withAnimation {
                            counter.step.addingWithoutOverflow(1)
                            modelContext.insertSave(counter)
                        }
                    }, label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .foregroundColor(customAccentColor)
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
                        .focused($isFocused, equals: .title)
                        .foregroundColor(.white)
                        .background(tBGColor(.title))
                } else {
                    Text(counter.title)
                        .foregroundColor(.white)
                }
                VStack {
                    HStack {
                        if isEditing {
                            TextField("Value", value: $counter.value, format: .number)
                                .focused($isFocused, equals: .value)
                                .foregroundColor(.white)
                                .background(tBGColor(.value))
#if os(iOS)
                                .keyboardType(.numberPad)
#endif
                        } else {
                            Text("\(counter.value)")
                                .foregroundColor(.white)
                        }
                    }
                    HStack {
                        Button(action: {
                            counter.decrement()
                            insertNewItem(counter)
                        }, label: {
                            Image(systemName: "minus.square")
                                .resizable()
                                .foregroundColor(customAccentColor)
                                .frame(width: 30, height: 30)
                        })
                        Spacer().frame(width: 45)
                        Button(action: {
                            counter.increment()
                            insertNewItem(counter)
                        }, label: {
                            Image(systemName: "plus.square")
                                .resizable()
                                .foregroundColor(customAccentColor)
                                .frame(width: 40, height: 40)
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
