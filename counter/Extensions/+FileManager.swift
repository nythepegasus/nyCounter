//
//  +FileManager.swift
//  nyCounter
//
//  Created by ny on 11/22/24.
//

import Foundation

protocol AppGroupID {
    var name: String { get }
}

extension AppGroupID {
    var container: URL? { FileManager.container(self) }
}

extension AppGroupID where Self: RawRepresentable, Self.RawValue == String {
    var name: String { rawValue }
}

extension FileManager {
    static func container(_ group: some AppGroupID) -> URL? {
        self.default.container(group)
    }
    
    func container<T: AppGroupID>(_ group: T) -> URL? {
        containerURL(forSecurityApplicationGroupIdentifier: group.name)
    }
}

extension URL {
    var isDirectory: Bool {
        var b: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &b) && b.boolValue
    }


    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid URL StaticString: \(string)")
        }
        self = url
    }
}
