//
//  +SDModels.swift
//  nyCounter
//
//  Created by ny on 11/22/24.
//

import Foundation

import SwiftData

@available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
extension PersistentModel {
    func insert(_ context: ModelContext) {
        context.insert(self)
    }
    
    func insertSave(_ context: ModelContext, _ errString: String? = nil) {
        context.insertSave(self, errString)
    }
    
    func delete(_ context: ModelContext) {
        context.delete(self)
    }
}

@available(macOS 14.0, iOS 17.0, tvOS 17.0, *)
extension ModelContext {
    func Save(_ errString: String? = nil) {
        if hasChanges {
            do {
                try save()
            } catch {
                print(errString ?? "Error saving model: \(error.localizedDescription)")
            }
        }
    }
    
    func insertSave<T>(_ model: T, _ errString: String? = nil) where T: PersistentModel {
        insert(model)
        Save()
    }
}
