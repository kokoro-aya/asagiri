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
    
//    var comments: String = ""
    
    init(name: String) {
        self.name = name
    }
}
