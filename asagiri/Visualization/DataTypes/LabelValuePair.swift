//
//  LabelValuePair.swift
//  asagiri
//
//  Created by irony on 29/11/2023.
//

import Foundation

struct LabelValuePair : Hashable {
    let label: String
    let value: Int
    
    let id: String
    
    init(label: String, value: Int) {
        self.label = label
        self.value = value
        self.id = UUID().uuidString
    }
}
