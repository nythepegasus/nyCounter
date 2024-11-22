//
//  +Int.swift
//  nyCounter
//
//  Created by ny on 11/22/24.
//

import Foundation

extension FixedWidthInteger {
    func addWithoutOverflow(_ other: Self) -> Self {
        let o = addingReportingOverflow(other)
        return o.overflow ? .max : o.partialValue
    }
    
    mutating func addingWithoutOverflow(_ other: Self) {
        self = addWithoutOverflow(other)
    }
    
    func subtractWithoutOverflow(_ other: Self) -> Self {
        let o = subtractingReportingOverflow(other)
        return o.overflow ? .min : o.partialValue
    }
    
    mutating func subtractingWithoutOverflow(_ other: Self) {
        self = subtractWithoutOverflow(other)
    }
}
