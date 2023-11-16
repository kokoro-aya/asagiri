//
//  Item.swift
//  asagiri
//
//  Created by irony on 16/11/2023.
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
