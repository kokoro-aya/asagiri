//
//  Tag.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import Foundation
import SwiftData

@Model
class Tag {
    
    var name: String
    
    var color: String?
    
    init(name: String) {
        self.name = name
    }
    
    // Dummy static value as a placeholder for management list
    static let empty: Tag = Tag(name: "")
    
}
