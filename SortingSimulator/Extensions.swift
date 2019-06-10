//
//  Extensions.swift
//  SortingSimulator
//
//  Created by OrigamiDream on 10/06/2019.
//  Copyright © 2019 OrigamiDream. All rights reserved.
//

import Foundation

extension Int {
    
    static func parse(from string: String) -> Int? {
        return Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
}
