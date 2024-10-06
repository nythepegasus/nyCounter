//
//  CounterListView.swift
//  nyCounter
//
//  Created by ny on 10/3/24.
//

import SwiftUI
import SwiftData

import nysuibits


struct CounterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \NYCounter.order) private var counters: [NYCounter]
    @Query private var countItems: [NYCountItem]
    @Environment(NYCounterModel.self) private var countModel
#if os(iOS)
    @State var mode: EditMode = .inactive
    #else
    @State var mode: Bool = false
#endif
    @State var refresh: Bool = false
    
    func bColor(_ c: NYCounter? = nil) -> Color {
        if let c {
            if let goal = c.goal {
                if goal <= c.value {
                    return Color.green.opacity(0.35)
                }
            }
        }
        return Color.gray.opacity(0.2)
    }
    
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
    
    var rowMax: CGFloat { 278 }
    
    var rowSize: CGFloat {
        isEditing ? rowMax : 120
    }
    
    var rows: [GridItem] {
        #if os(iOS)
        if isEditing {
            return [GridItem(.adaptive(minimum: rowSize, maximum: .infinity))]
        }
        #endif
        return [GridItem(.adaptive(minimum: rowSize, maximum: rowMax))]
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: addCounter) {
                    Image(systemName: "plus.circle")
                }
                Button(action: {
                    toggleEditing()
                }, label: {
                    Text(isEditing ? "Done" : "Edit")
                })
                .padding()
            }
            ScrollView(.horizontal) {
                Spacer()
                VStack {
                    LazyHGrid(rows: rows) {
                        ForEach(counters) { counter in
                            NYCounterView(counter: counter, mode: $mode, onDelete: {
                                if let offsets = counters.firstIndex(of: counter) {
                                    deleteCounters(offsets: IndexSet(integer: offsets))
                                }
                            })
                                .padding()
                                .background(bColor(counter))
                                .cornerRadius(15)
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
#if os(iOS)
                                .background(bColor())
                                .cornerRadius(15)
#endif
                            }
                        }
                    }
                }
            }
        }
        .onAppear(perform: beginStuff)
        
    }
    
    func beginStuff() {
        Task {
            try await countModel.fetchCounters()
            try await countModel.fetchCountItems()
        }
        cleanUpOrphanedCountItems()
        numberCounters()
    }
    
    func addCounter() {
        withAnimation {
            let newCounter = NYCounter(order: countModel.highestOrder, value: 0, title: "Counter", step: 1)
            NYCountItem(counter: newCounter, value: 0).insertSave(modelContext, "Error while inserting new counter item for \(newCounter.title)")
            newCounter.insertSave(modelContext, "Error adding new counter \(newCounter.title)")
        }
    }
    
    private func deleteCounters(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                if counters.indices.contains(index) {
                    let counter = counters[index]
                    if let items = counter.items {
                        items.forEach { modelContext.delete($0) }
                    }
                    
                    for item in countItems where item.counter == counter {
                        modelContext.delete(item)
                    }
                    modelContext.delete(counter)

                }
                
            }
        }
        modelContext.Save("Error while saving while deleting counters")
    }
    
    func numberCounters() {
        for counter in counters {
            if counter.order < 0 {
                counter.order = countModel.highestOrder
                counter.insertSave(modelContext)
            }
        }
    }
    
    func cleanUpOrphanedCountItems() {
        for item in countItems {
            if item.counter.isNil ||
//              counters.first(where: { $0 == item.counter }) == nil {
                counters.first(where: { $0 == item.counter }).isNil {
                modelContext.delete(item)
            }
        }
        modelContext.Save("Error saving while cleaning up orphaned count items")
    }
}

#Preview {
    CounterListView()
        .modelContainer(for: NYCounter.self, inMemory: true)
}
