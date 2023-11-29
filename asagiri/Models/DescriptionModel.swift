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
    
    var company: Company?
    
    var type: CareerType?
    
    var intro: String = ""
    
    var companyIntro: String = ""
    
    var responsibilities: String = ""
    
    var complementary: String = ""
    
//    var comments: String = ""
    
    init(title: String, company: Company, type: CareerType) {
        self.title = title
        self.company = company
        self.type = type
    }
    
    init(title: String, company: Company?, type: CareerType?, intro: String, companyIntro: String, responsibilities: String, complementary: String) {
        self.title = title
        self.company = company
        self.type = type
        self.intro = intro
        self.companyIntro = companyIntro
        self.responsibilities = responsibilities
        self.complementary = complementary
    }
}
