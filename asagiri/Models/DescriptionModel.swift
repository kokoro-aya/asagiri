//
//  DescriptionModel.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftData

@Model
final class JobDescription {
    var title: String
    
    var type: CareerType?
    
    var intro: String = ""
    
    var companyIntro: String = ""
    
    var responsibilities: String = ""
    
    var complementary: String = ""
    
//    var comments: String = ""
    
    init(title: String, type: CareerType) {
        self.title = title
        self.type = type
    }
}
