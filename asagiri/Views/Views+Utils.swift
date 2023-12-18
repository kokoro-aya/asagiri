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
//  Utils.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import Foundation
import SwiftData


// The common function across various preview views to initialize an empty data scheme before rendering the scene
@MainActor
func initializePreviewContainer() -> ModelContainer {
    let previewContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            
            Application.self,
            Organization.self,
            Resume.self,
            CoverLetter.self,
            JobDescription.self,
            CareerType.self,
            Event.self,
            Tag.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer for preview: \(error)")
        }
    }()
    
    // Remove existing applications just for preview
    do {
        try previewContainer.mainContext.delete(model: Application.self)
        try previewContainer.mainContext.delete(model: Organization.self)
        try previewContainer.mainContext.delete(model: Resume.self)
        try previewContainer.mainContext.delete(model: CoverLetter.self)
        try previewContainer.mainContext.delete(model: JobDescription.self)
        try previewContainer.mainContext.delete(model: CareerType.self)
        try previewContainer.mainContext.delete(model: Event.self)
        try previewContainer.mainContext.delete(model: Tag.self)
    } catch {
        fatalError(error.localizedDescription)
    }
    
    return previewContainer
}


// Create a date from a string literal
func createDateFromString(_ s: String) -> Date {
    let RFC3339DateFormatter = DateFormatter()
    RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
    RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    return RFC3339DateFormatter.date(from: s)!
}

var monthStarts: Date {
    let month = Calendar.current.dateComponents([.year, .month], from: .now)
    return Calendar.current.date(from: month)!
}

@MainActor
func prepareDummyApplicationDataForAnalyticViews(container: inout ModelContainer) {
    let applications = [
        Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")),
                    dateCreated: createDateFromString("2023-10-10T12:00:00-08:00"), events: [
            Event(type: .applied, updateTime: createDateFromString("2023-10-12T12:00:00-08:00")),
            Event(type: .rejected, updateTime: createDateFromString("2023-10-13T14:50:00-08:00"))
        ]),
        Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), 
                    dateCreated: createDateFromString("2023-10-10T12:00:00-08:00"), events: [
            Event(type: .applied, updateTime: createDateFromString("2023-10-11T12:00:00-08:00")),
            Event(type: .interview(round: 1), updateTime: createDateFromString("2023-10-12T21:00:00-08:00")),
            Event(type: .interview(round: 2), updateTime: createDateFromString("2023-10-16T15:20:00-08:00")),
            Event(type: .interview(round: 3), updateTime: createDateFromString("2023-10-19T14:00:00-08:00"))
        ]),
        Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), 
                    dateCreated: createDateFromString("2023-09-10T12:00:00-08:00"), events: [
            Event(type: .applied, updateTime: createDateFromString("2023-10-17T12:00:00-08:00")),
            Event(type: .interview(round: 1), updateTime: createDateFromString("2023-10-18T14:30:00-08:00")),
            Event(type: .ghost, updateTime: createDateFromString("2023-10-22T14:20:00-08:00"))
        ]),
        Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")),
                    dateCreated: createDateFromString("2023-09-12T12:00:00-08:00"), events: [
            Event(type: .applied, updateTime: createDateFromString("2023-10-22T13:50:00-08:00"))
        ]),
        Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), 
                    dateCreated: createDateFromString("2023-10-22T12:00:00-08:00"), events: [
            Event(type: .applied, updateTime: createDateFromString("2023-10-22T13:50:00-08:00")),
            Event(type: .oa, updateTime: createDateFromString("2023-11-15T13:00:00-08:00"))
        ])
    ]
    
    applications.forEach {
        container.mainContext.insert($0)
    }
}
