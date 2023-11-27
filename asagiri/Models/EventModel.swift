//
//  EventModel.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import Foundation
import SwiftData

@Model
final class Event {
    var type: ApplicationStatus

    var updateTime: Date

    init(type: ApplicationStatus, updateTime: Date = .now) {
        self.type = type
        self.updateTime = updateTime
    }
}
