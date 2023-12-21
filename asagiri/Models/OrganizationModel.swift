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
//  OrganizationModel.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftData

@Model
final class Organization : Codable, Comparable {

    var name: String
    var website: String
    
//    var comments: String = ""
    
    @Relationship(deleteRule: .cascade, inverse: \JobDescription.organization)
    var positions: [JobDescription] = []
    
    init(name: String, website: String) {
        self.name = name
        self.website = website
    }
    
    // Boilerplates for codable conformance
    enum CodingKeys: CodingKey {
        case name, website, positions
    }
    
    required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey(rawValue: "modelcontext")!] as? ModelContext else {
            fatalError()
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.website = try container.decode(String.self, forKey: .website)
        
        self.positions = try container.decode([JobDescription].self, forKey: .positions)
        
        // Persist data with its relationship
        context.insert(self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(website, forKey: .website)
        
        try container.encode(positions, forKey: .positions)
    }
    
    // For comparison purpose
    static func < (lhs: Organization, rhs: Organization) -> Bool {
        return lhs.name < rhs.name
    }
}
