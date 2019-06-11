//
//  SortingValue.swift
//  SortingSimulator
//
//  Created by OrigamiDream on 10/06/2019.
//  Copyright © 2019 OrigamiDream. All rights reserved.
//

import Foundation
import Cocoa

class SortingValue: Comparable {
    
    static func < (lhs: SortingValue, rhs: SortingValue) -> Bool {
        return lhs.value < rhs.value
    }
    
    static func == (lhs: SortingValue, rhs: SortingValue) -> Bool {
        return lhs.value == rhs.value
    }
    
    public var value: Int
    public var color: NSColor
    
    init(value: Int) {
        self.value = value
        self.color = .white
    }
    
}
