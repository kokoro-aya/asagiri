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

    var jobDescription: JobDescription

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

    init(jobDescription: JobDescription, resume: Resume? = nil, cover: CoverLetter? = nil, dateCreated: Date = .now, events: [Event] = []) {
        self.jobDescription = jobDescription
        self.dateCreated = Date.now
        self.resume = resume
        self.cover = cover
        self.dateCreated = dateCreated
        self.events = events
    }
}
