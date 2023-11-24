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
        events.last?.type ?? .not_started
    }

    init(jobDescription: JobDescription) {
        self.jobDescription = jobDescription
        self.dateCreated = Date.now
    }
}
