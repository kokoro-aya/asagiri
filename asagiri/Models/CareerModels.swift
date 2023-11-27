//
//  Career.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import Foundation
import SwiftData

@Model
final class CareerType {
    var name: String
    
    var symbol: String?
    
//    var comments: String = ""
    
    init(name: String) {
        self.name = name
    }
    
    // Dummy static value as a placeholder for management list
    static let empty = CareerType(name: "")
}
