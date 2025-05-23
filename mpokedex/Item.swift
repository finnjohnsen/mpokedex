//
//  Item.swift
//  mpokedex
//
//  Created by Finn J Johnsen on 23/05/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
