//
//  SortingValue.swift
//  SortingSimulator
//
//  Created by OrigamiDream on 10/06/2019.
//  Copyright © 2019 OrigamiDream. All rights reserved.
//

import Foundation
import Cocoa

class SortingValue {
    
    public private(set) var value: Double
    public var color: NSColor
    
    init(value: Double) {
        self.value = value
        self.color = .white
    }
    
}
