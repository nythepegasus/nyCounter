//
//  CounterListView.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import SwiftUI
import SwiftData


struct CounterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NYCounter.title) private var counters: [NYCounter]
    @State var curCounters: [NYCounter] = []
#if os(iOS)
    @State var mode: EditMode = .inactive
    #else
    @State var mode: Bool = false
#endif
    @State var refresh: Bool = false
    
    var body: some View {
        VStack {
            #if os(iOS)
            HStack {
                Spacer()
                Button(action: {
                    if mode == .inactive {
                        mode = .active
                    } else if mode == .active {
                        mode = .inactive
                    }
                }, label: {
                    Text(mode == .active ? "Done" : "Edit")
                })
                .padding()
            }
            #else
            HStack {
                Spacer()
                Button(action: {
                    mode.toggle()
                }, label: {
                    Text(mode ? "Done" : "Edit")
                })
                .padding()
            }

            #endif
            ScrollView(.horizontal) {
                VStack {
                    Spacer()
                    HStack {
                        ForEach(counters) { counter in
                            NYCounterView(counter: counter, editMode: $mode, onDelete: {
                                if let offsets = counters.firstIndex(of: counter) {
                                    deleteCounters(offsets: IndexSet(integer: offsets))
                                }
                            })
                                .onTapGesture {
                                    print("tapped \(counter.id)")
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                        }
                        .onDelete(perform: deleteCounters)
                        HStack {
                            Button(action: addCounter) {
                                VStack {
                                    Image(systemName: "plus.circle")
                                        .font(.largeTitle)
                                    Text("Add Counter")
                                }
                                .padding()
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
    
    func addCounter() {
        withAnimation {
            let newCounter = NYCounter(value: 0, title: "Counter", step: 1)
            let newCounterItem = NYCountItem(counter: newCounter, value: 0)
//            newCounter.items?.append(newCounterItem)
            modelContext.insert(newCounter)
            modelContext.insert(newCounterItem)
        }
    }
    
    private func deleteCounters(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(counters[index])
            }
        }
    }
}

#Preview {
    CounterListView()
        .modelContainer(for: NYCounter.self, inMemory: true)
}
