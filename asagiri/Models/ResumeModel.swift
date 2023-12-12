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
//  ResumeModel.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftData

@Model
final class Resume : Codable {
    var content: String
    
    var comments: String = ""
    
    var createTime: Date
    
    init(content: String) {
        self.content = content
        self.createTime = Date.now
    }
    
    // Boilerplates for codable conformance
    enum CodingKeys: CodingKey {
        case content, comments, createTime
    }
    
    required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey(rawValue: "modelcontext")!] as? ModelContext else {
            fatalError()
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.content = try container.decode(String.self, forKey: .content)
        self.comments = try container.decode(String.self, forKey: .comments)
        self.createTime = try container.decode(Date.self, forKey: .createTime)
//        context.insert(self)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(content, forKey: .content)
        try container.encode(comments, forKey: .comments)
        try container.encode(createTime, forKey: .createTime)
    }
}
