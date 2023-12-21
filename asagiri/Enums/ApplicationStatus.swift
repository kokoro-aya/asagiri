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

enum ApplicationStatus : Codable, Hashable, Identifiable, Comparable {
    
    var id: Self {
        return self
    }
    
    case notStarted
    case preparation
    case applied
    case oa
    case phoneScreen
    case technicalTest
    case interview(round: Int)
    case rejected
    case offer
    case ghost
    
    case archived
    
    func color() -> Color {
        return switch self {
        case .notStarted: .black
        case .preparation: .black
        case .applied: .yellow
        case .oa: .purple
        case .technicalTest: .indigo
        case .phoneScreen: .orange
        case .interview(_): .orange
        case .rejected: .gray
        case .offer: .green
        case .ghost: .red
            
        case .archived: .gray
        }
    }
    
    func possibleNexts() -> [ApplicationStatus] {
        return switch self {
        case .notStarted: [.preparation, .applied]
        case .preparation: [.applied]
        case .applied: [.oa, .phoneScreen, .interview(round: 1), .rejected, .offer]
        case .oa: [.phoneScreen, .technicalTest, .interview(round: 1), .rejected]
        case .phoneScreen: [.technicalTest, .interview(round: 1), .rejected]
        case .technicalTest: [.interview(round: 1), .rejected]
        case .interview(let round): [.interview(round: round + 1), .rejected, .offer]
        case .rejected: []
        case .offer: [.rejected, .ghost]
        case .ghost: []
        case .archived: []
        }
    }
    
    func canArchive() -> Bool {
        return switch self {
        case .archived: false
        default: true
        }
    }
}

extension ApplicationStatus : CustomStringConvertible {
    var description: String {
        return switch self {
            case .notStarted: "Not Started"
            case .preparation: "Preparation"
            case .applied: "Applied"
            case .oa: "OA"
            case .technicalTest: "Technical Test"
            case .phoneScreen: "Phone Screen"
            case .interview(let round): "Int. round \(round)"
            case .rejected: "Rejected"
            case .offer: "Offer"
            case .ghost: "Ghosted"
            case .archived: "Archived"
        }
    }
}
