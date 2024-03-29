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
//  ApplicationModel.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftData

@Model
final class Application : Codable, Comparable {

    
    @Relationship
    var jobDescription: JobDescription? = nil

    @Relationship
    var resume: Resume? = nil

    @Relationship
    var cover: CoverLetter? = nil

    var dateCreated: Date

    var events: [Event] = []

    var status: ApplicationStatus  {
        get {
            events.sorted(by: { $0.updateTime < $1.updateTime }).last?.type ?? .notStarted
        }
    }
    
    func setArchived() {
        events.append(Event(type: .archived))
    }
    
    var lastEvent: Event? {
        events.sorted(by: { $0.updateTime < $1.updateTime }).last
    }
    
    init() {
        self.dateCreated = .now
        self.events = []
    }

    init(jobDescription: JobDescription, resume: Resume? = nil, cover: CoverLetter? = nil, dateCreated: Date = .now, events: [Event] = []) {
        self.jobDescription = jobDescription
        self.resume = resume
        self.cover = cover
        self.dateCreated = dateCreated
        self.events = events
    }
    
    // Boilerplates for codable conformance
    enum CodingKeys: CodingKey {
        case dateCreated, resume, cover, events
    }
    
    required init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey(rawValue: "modelcontext")!] as? ModelContext else {
            fatalError()
        }
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resume = try? container.decode(Resume?.self, forKey: .resume)
        self.cover = try? container.decode(CoverLetter?.self, forKey: .cover)
        self.dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        self.events = try container.decode([Event].self, forKey: .events)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(resume, forKey: .dateCreated)
        try container.encode(cover, forKey: .cover)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(events, forKey: .events)
    }
    
    // For comparison purpose
    static func < (lhs: Application, rhs: Application) -> Bool {
        if let lj = lhs.jobDescription, let rj = rhs.jobDescription {
            return lj < rj
        }
        if lhs.dateCreated < rhs.dateCreated {
            return true
        }
        return false
    }
}
