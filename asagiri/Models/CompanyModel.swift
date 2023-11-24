//
//  CompanyModel.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftData

@Model
final class Company {
    var name: String
    var website: String
    
//    var comments: String = ""
    
    var positions: [JobDescription] = []
    
    init(name: String, website: String) {
        self.name = name
        self.website = website
    }
}
