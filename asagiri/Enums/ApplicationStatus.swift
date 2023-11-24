//
//  ApplicationStatus.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation

enum ApplicationStatus {
    case not_started
    case preparation
    case applied
    case phone_screen
    case interview(round: Int?)
    case rejected
    case offer
}
