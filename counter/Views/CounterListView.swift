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
    @Query(sort: \NYCounter.id) private var counters: [NYCounter]
    @Query private var allCountItems: [NYCountItem]
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
        .onAppear(perform: cleanUpOrphanedCountItems)
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
                let counter = counters[index]
                
                // Fetch and delete associated NYCountItems
                if let items = counter.items {
                    for item in items {
                        modelContext.delete(item)
                    }
                }
                modelContext.delete(counter)
            }
        }
    }
    
    func cleanUpOrphanedCountItems() {
        for item in allCountItems {
            // Check if there's no associated NYCounter
            if item.counter == nil {
                modelContext.delete(item)
            }
        }
        
        do {
            // Save the context to apply the deletions
            try modelContext.save()
        } catch {
            print("Failed to clean up orphaned NYCountItems: \(error.localizedDescription)")
        }
    }
}

#Preview {
    CounterListView()
        .modelContainer(for: NYCounter.self, inMemory: true)
}
