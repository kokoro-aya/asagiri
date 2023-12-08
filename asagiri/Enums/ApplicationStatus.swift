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
    
    case archived
    
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
            
        case .archived: .gray
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
        case .archived: []
        }
    }
    
//     Seems that the enums with SwiftData are broken in deserializing JSON files
//     as mentioned here: https://stackoverflow.com/questions/76645050/error-trying-to-use-swiftdata-property-based-on-an-enum-with-an-associated-value
//     A walkthrough for the current Xcode and iOS versions
    
//     The following codes will not work as creating a data and accessing it will throw an error of type:
//     > Could not cast value of type '() -> ()' (0x103047210) to 'Swift.String' (0x1f482a7c0) - if we attempt to decode the enum
//     > The code snippet has two arms regarding whether the case has an associated value
//     > But the container.allKeys will always have only one element, like `CodingKeys(stringValue: "preparation", intValue: nil)`
//     > And the code will fail
    
//    enum CodingKeys : CodingKey {
//        case not_started, preparation, applied, oa, phone_screen, technical_test, interview, rejected, offer, ghost, archived
//        case interview__arg0
//    }
//    
//    init(from decoder: Decoder) throws {
//        do {
//            let container = try decoder.container(keyedBy: CodingKeys.self)
//            var allKeys = ArraySlice(container.allKeys)
//            if let oneKey = allKeys.popFirst(), allKeys.isEmpty {
//                // There is only a key for the associated value cases
//                if container.contains(.interview) {
//                    let sub = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: oneKey)
//                    let val = try sub.decode(Int.self, forKey: .interview__arg0)
//                    self = .interview(round: val)
//                } else {
//                    // Only reached for the cases with no associated value
//                    let container = try decoder.singleValueContainer()
//                    let val = try container.decode(String.self)
//                    switch val {
//                    case "not_started": self = .not_started
//                    case "preparation": self = .preparation
//                    case "applied": self = .applied
//                    case "oa": self = .oa
//                    case "technical_test": self = .technical_test
//                    case "phone_screen": self = .phone_screen
//                    case "rejected": self = .rejected
//                    case "offer": self = .offer
//                    case "ghost": self = .ghost
//                    case "archived": self = .archived
//                    default:
//                        throw DecodingError.typeMismatch(ApplicationStatus.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "Custom Error: Unexpected associated value of '\(val)'", underlyingError: nil))
//                    }
//                }
//            } else {
//                throw DecodingError.typeMismatch(ApplicationStatus.self, DecodingError.Context.init(codingPath: container.codingPath, debugDescription: "Custom Error: Empty", underlyingError: nil))
//            }
//        } catch {
//            print(error)
//            throw error
//        }
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        print ("encode \(self)")
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        switch self {
//        case .not_started:
//            try! container.encode("not_started", forKey: .not_started)
//        case .preparation:
//            try! container.encode("preparation", forKey: .preparation)
//        case .applied:
//            try! container.encode("applied", forKey: .applied)
//        case .oa:
//            try! container.encode("oa", forKey: .oa)
//        case .technical_test:
//            try! container.encode("technical_test", forKey: .technical_test)
//        case .phone_screen:
//            try! container.encode("phone_screen", forKey: .phone_screen)
//        case .interview(let val):
//            try! container.encode(val, forKey: .interview)
//        case .rejected:
//            try! container.encode("rejected", forKey: .rejected)
//        case .offer:
//            try! container.encode("offer", forKey: .offer)
//        case .ghost:
//            try! container.encode("ghost", forKey: .ghost)
//        case .archived:
//            try! container.encode("archived", forKey: .archived)
//        }
//    }
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
            case .archived: "Archived"
        }
    }
}
