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
final class Application {

    var jobDescription: JobDescription? = nil

    var resume: Resume? = nil

    var cover: CoverLetter? = nil

    var dateCreated: Date

    var events: [Event] = []

    var status: ApplicationStatus {
        events.sorted(by: { $0.updateTime < $1.updateTime }).last?.type ?? .not_started
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
        self.dateCreated = Date.now
        self.resume = resume
        self.cover = cover
        self.dateCreated = dateCreated
        self.events = events
    }
}
