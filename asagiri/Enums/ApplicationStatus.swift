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
//  ApplicationStatus.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import Foundation
import SwiftUI

enum ApplicationStatus : Codable, Hashable, Identifiable {
    
    var id: Self {
        return self
    }
    
    case not_started
    case preparation
    case applied
    case oa
    case phone_screen
    case technical_test
    case interview(round: Int)
    case rejected
    case offer
    case ghost
    
    func color() -> Color {
        return switch self {
            case .not_started: .black
            case .preparation: .black
            case .applied: .yellow
            case .oa: .purple
            case .technical_test: .indigo
            case .phone_screen: .orange
            case .interview(_): .orange
            case .rejected: .gray
            case .offer: .green
            case .ghost: .red
        }
    }
    
    func possibleNexts() -> [ApplicationStatus] {
        return switch self {
        case .not_started: [.preparation, .applied]
        case .preparation: [.applied]
        case .applied: [.oa, .phone_screen, .interview(round: 1), .rejected, .offer]
        case .oa: [.phone_screen, .technical_test, .interview(round: 1), .rejected]
        case .phone_screen: [.technical_test, .interview(round: 1), .rejected]
        case .technical_test: [.interview(round: 1), .rejected]
        case .interview(let round): [.interview(round: round + 1), .rejected, .offer]
        case .rejected: []
        case .offer: [.rejected, .ghost]
        case .ghost: []
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
            case .oa: "OA"
            case .technical_test: "Technical Test"
            case .phone_screen: "Phone Screen"
            case .interview(let round): "Int. round \(round)"
            case .rejected: "Rejected"
            case .offer: "Offer"
            case .ghost: "Ghosted"
        }
    }
}
