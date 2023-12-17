////  Licensed under GPL v3 License.
//
//  kokoro-aya/asagiri
//  Copyright (c) 2023 . All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License along with Foobar. If not, see <https://www.gnu.org/licenses/>.
//
//  DescriptionModel.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftData

@Model
final class JobDescription : Codable, Comparable {
    
    var title: String
    
    @Relationship
    var application: Application? = nil
    
    @Relationship(deleteRule: .cascade)
    var organization: Organization?
    
    var type: CareerType?
    
    var intro: String = ""
    
    var orgIntro: String = ""
    
    var responsibilities: String = ""
    
    var complementary: String = ""
    
//    var comments: String = ""
    
    init(title: String, organization: Organization, type: CareerType) {
        self.title = title
        self.organization = organization
        self.type = type
    }
    
    init(title: String, organization: Organization?, type: CareerType?, intro: String, orgIntro: String, responsibilities: String, complementary: String) {
        self.title = title
        self.organization = organization
        self.type = type
        self.intro = intro
        self.orgIntro = orgIntro
        self.responsibilities = responsibilities
        self.complementary = complementary
    }
    
    // Boilerplates for codable conformance
    enum CodingKeys: CodingKey {
        case title, application, type, intro, orgIntro, responsibilities, complementary
    }
    
    required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey(rawValue: "modelcontext")!] as? ModelContext else {
            fatalError()
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.application = try? container.decode(Application?.self, forKey: .application)
        
        self.type = try? container.decode(CareerType?.self, forKey: .type)
        self.intro = try container.decode(String.self, forKey: .intro)
        self.orgIntro = try container.decode(String.self, forKey: .orgIntro)
        self.responsibilities = try container.decode(String.self, forKey: .responsibilities)
        self.complementary = try container.decode(String.self, forKey: .complementary)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(application, forKey: .application)
        try container.encode(type, forKey: .type)
        try container.encode(intro, forKey: .intro)
        try container.encode(orgIntro, forKey: .orgIntro)
        try container.encode(responsibilities, forKey: .responsibilities)
        try container.encode(complementary, forKey: .complementary)
    }
    
    // For comparison purpose
    static func < (lhs: JobDescription, rhs: JobDescription) -> Bool {
        if lhs.title < rhs.title {
            return true
        }
        if let lt = lhs.type, let rt = rhs.type {
            return lt < rt
        }
        if let lo = lhs.organization, let ro = rhs.organization {
            return lo < ro
        }
        return false
    }
}
