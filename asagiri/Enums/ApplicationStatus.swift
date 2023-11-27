//
//  ApplicationStatus.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftUI

enum ApplicationStatus : Codable {
    case not_started
    case preparation
    case applied
    case phone_screen
    case interview(round: Int?)
    case rejected
    case offer
    
    func color() -> Color {
        return switch self {
            case .not_started: .black
            case .preparation: .black
            case .applied: .yellow
            case .phone_screen: .orange
            case .interview(_): .orange
            case .rejected: .gray
            case .offer: .green
        }
    }
}

// must conform `Codable` protocol otherwise compiler will yell
//   "No exact matches in call to instance method 'getValue'" for usage in models

extension ApplicationStatus : CustomStringConvertible {
    var description: String {
        return switch self {
            case .not_started: "Not Started"
            case .preparation: "Preparation"
            case .applied: "Applied"
            case .phone_screen: "Phone Screen"
            case .interview(let round): round == nil ? "Interview" : "Int. round \(round!)"
            case .rejected: "Rejected"
            case .offer: "Offer"
        }
    }
}
