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
import SwiftUI

struct TagChip: View {
    let text: String
    
    let onDelete: (any Hashable) -> ()
    
    var body: some View {
        HStack {
            Text(text)
                .font(.callout)
                .foregroundColor(.black)
            Button {
                onDelete(text)
            } label: {
                Image(systemName: "multiply")
                    .foregroundColor(.black)
                    .frame(width: 16, height: 16)
            }
        }
        .padding(8)
        .background(RoundedRectangle(cornerRadius: 16))
        .foregroundColor(.gray.opacity(0.5))
    }
}

#Preview {
    TagChip(text: "Hello", onDelete: { _ in })
}

struct ApplicationSortingOptionsView: View {

    @Binding var criteria: [ApplicationSortOption]
    
    func add(criterion: ApplicationSortOption) {
        if !criteria.contains(criterion) {
            criteria.append(criterion)
        }
    }
    
    var body: some View {
        Text("")
    }
}

#Preview {
    ApplicationSortingOptionsView(criteria: .constant([.byCareer, .byCreationDate, .byTitle]))
}

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

func nonNilcompare<T: Comparable>(a: T, b: T) -> ComparisonResult {
    if a < b {
        return .orderedAscending
    } else if a > b {
        return .orderedDescending
    } else {
        return .orderedSame
    }
}

// Adaped from `nilComparator` here:
// source: https://stackoverflow.com/questions/44808391/why-cant-swifts-greater-than-or-less-than-operators-compare-optionals-when-the/44808567#44808567
func nilComparator<T: Comparable>(lhs: T?, rhs: T?, nilsAtEnd: Bool) -> ComparisonResult {
    return switch (lhs, rhs) {
    case (nil, nil):  .orderedSame
    case (nil, _?):  nilsAtEnd ? .orderedDescending : .orderedAscending
    case (_?, nil):  nilsAtEnd ? .orderedAscending : .orderedDescending
    case let (a?, b?):  nonNilcompare(a: a, b: b)
    }
}

enum ApplicationSortOption {
    case byTitle, byCareer, byCreationDate, byLastUpdateDate
}

let applicationComparators: [ApplicationSortOption : (Application, Application) -> ComparisonResult] = [
    .byTitle: { lhs, rhs in
        nilComparator(lhs: lhs.jobDescription?.title, rhs: rhs.jobDescription?.title, nilsAtEnd: false)
    },
    .byCareer: { lhs, rhs in
        nilComparator(lhs: lhs.jobDescription?.type?.name, rhs: rhs.jobDescription?.type?.name, nilsAtEnd: false)
    },
    .byCreationDate: { lhs, rhs in
        nilComparator(lhs: lhs.jobDescription?.application?.dateCreated, rhs: rhs.jobDescription?.application?.dateCreated, nilsAtEnd: false)
    },
    .byLastUpdateDate: { lhs, rhs in
        nilComparator(lhs: lhs.jobDescription?.application?.lastEvent?.updateTime, rhs: rhs.jobDescription?.application?.lastEvent?.updateTime, nilsAtEnd: false)
    }
]

