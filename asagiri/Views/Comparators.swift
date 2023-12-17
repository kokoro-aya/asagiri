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
//  Comparators.swift
//  asagiri
//
//  Created by irony on 15/12/2023.
//

import Foundation

/**
   Uses multiple comparators to sort the source, this function calls the `sorted` method to return a copy or original list sorted
 */
func sortByMultiComparators<T: Comparable>(source: [T], comparators: [(T, T) -> ComparisonResult]) -> [T] {
    source.sorted(by: { lhs, rhs in
        for cmp in comparators {
            let curr = cmp(lhs, rhs)
            if curr != .orderedAscending {
                return true
            } else {
                continue
            }
        }
        return false
    })
}

func nonNilAscendingCompare<T: Comparable>(a: T, b: T) -> ComparisonResult {
    if a < b {
        return .orderedAscending
    } else if a > b {
        return .orderedDescending
    } else {
        return .orderedSame
    }
}

func nonNilDescendingCompare<T: Comparable>(a: T, b: T) -> ComparisonResult {
    if a < b {
        return .orderedDescending
    } else if a > b {
        return .orderedAscending
    } else {
        return .orderedSame
    }
}



// Adaped from `nilComparator` here:
// source: https://stackoverflow.com/questions/44808391/why-cant-swifts-greater-than-or-less-than-operators-compare-optionals-when-the/44808567#44808567
func nilAscendingComparator<T: Comparable>(lhs: T?, rhs: T?, nilsAtEnd: Bool) -> ComparisonResult {
    return switch (lhs, rhs) {
    case (nil, nil):  .orderedSame
    case (nil, _?):  nilsAtEnd ? .orderedDescending : .orderedAscending
    case (_?, nil):  nilsAtEnd ? .orderedAscending : .orderedDescending
    case let (a?, b?):  nonNilAscendingCompare(a: a, b: b)
    }
}

func nilDescendingComparator<T: Comparable>(lhs: T?, rhs: T?, nilsAtEnd: Bool) -> ComparisonResult {
    return switch (lhs, rhs) {
    case (nil, nil):  .orderedSame
    case (nil, _?):  nilsAtEnd ? .orderedDescending : .orderedAscending
    case (_?, nil):  nilsAtEnd ? .orderedAscending : .orderedDescending
    case let (a?, b?):  nonNilDescendingCompare(a: a, b: b)
    }
}

struct ApplicationSortOption : Hashable {
    
    var type: ApplicationSortOptionType
    var direction: ApplicationSortDirection
    
    init(type: ApplicationSortOptionType, direction: ApplicationSortDirection) {
        self.type = type
        self.direction = direction
    }
    
    static let applicationComparators: [ApplicationSortOptionType : ApplicationComparatorPair] = [
        .byTitle: (
            ascending: { lhs, rhs in nilAscendingComparator(lhs: lhs.jobDescription?.title, rhs: rhs.jobDescription?.title, nilsAtEnd: false) },
            descending: { lhs, rhs in nilDescendingComparator(lhs: lhs.jobDescription?.title, rhs: rhs.jobDescription?.title, nilsAtEnd: false) }
        )
        ,
        .byCareer: (
            ascending: { lhs, rhs in nilAscendingComparator(lhs: lhs.jobDescription?.type?.name, rhs: rhs.jobDescription?.type?.name, nilsAtEnd: false) },
            descending: { lhs, rhs in nilDescendingComparator(lhs: lhs.jobDescription?.type?.name, rhs: rhs.jobDescription?.type?.name, nilsAtEnd: false) }
        )
            
        ,
        .byCreationDate: (
            ascending: { lhs, rhs in nilAscendingComparator(lhs: lhs.jobDescription?.application?.dateCreated, rhs: rhs.jobDescription?.application?.dateCreated, nilsAtEnd: false) },
            descending: { lhs, rhs in nilDescendingComparator(lhs: lhs.jobDescription?.application?.dateCreated, rhs: rhs.jobDescription?.application?.dateCreated, nilsAtEnd: false) }
        )
        ,
        .byLastUpdateDate: (
            ascending: { lhs, rhs in nilAscendingComparator(lhs: lhs.jobDescription?.application?.lastEvent?.updateTime, rhs: rhs.jobDescription?.application?.lastEvent?.updateTime, nilsAtEnd: false) },
            descending: { lhs, rhs in nilDescendingComparator(lhs: lhs.jobDescription?.application?.lastEvent?.updateTime, rhs: rhs.jobDescription?.application?.lastEvent?.updateTime, nilsAtEnd: false) }
        )
    ]
    
    static func findComparators(options: [ApplicationSortOption]) -> [ApplicationComparator] {
        return options.map {
            let ty = applicationComparators[$0.type]!
            if $0.direction == .ascending {
                return ty.ascending
            } else {
                return ty.descending
            }
        }
    }
}

enum ApplicationSortOptionType : Identifiable, CustomStringConvertible, CaseIterable {
    var id: Self {
        return self
    }
    
    case byTitle, byCareer, byCreationDate, byLastUpdateDate
    
    var description: String {
        switch self {
            case .byTitle:
                "by title"
            case .byCareer:
                "by career"
            case .byCreationDate:
                "by date created"
            case .byLastUpdateDate:
                "by date last updated"
        }
    }
}

enum ApplicationSortDirection : Identifiable, CustomStringConvertible, CaseIterable {
    var id: Self {
        return self
    }
    
    case ascending, descending
    
    static prefix func !(dir: ApplicationSortDirection) -> ApplicationSortDirection {
        return switch dir {
        case .ascending: .descending
        case .descending: .ascending
        }
    }
    
    var description: String {
        switch self {
        case .ascending: "ascending"
        case .descending: "descending"
        }
    }
}

typealias ApplicationComparator = (Application, Application) -> ComparisonResult
typealias ApplicationComparatorPair = (ascending: ApplicationComparator, descending: ApplicationComparator)

