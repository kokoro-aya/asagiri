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
//  ApplicationListSortingPart.swift
//  asagiri
//
//  Created by irony on 16/12/2023.
//

import SwiftUI
import WrappingHStack

struct ApplicationSortingOptionsView: View {

    @Binding var criteria: [ApplicationSortOption]
    
    func add(criterion: ApplicationSortOption) {
        if !criteria.contains(where: { $0.type == criterion.type}) {
            criteria.append(criterion)
        }
    }
    
    func remove(criterion: ApplicationSortOption) {
        if let pos = criteria.firstIndex(where: { $0.type == criterion.type }) {
            criteria.remove(at: pos)
        }
    }
    
    func removeAll() {
        criteria.removeAll()
    }
    
    var body: some View {
        HStack(alignment: .top) {
            WrappingHStack($criteria) { $crit in
                TagChip(option: $crit, onDelete: { crit in
                    remove(criterion: crit)
                })
                .padding([.top, .bottom], 4)
            }
            Spacer()
            Menu {
                ForEach(ApplicationSortOptionType.allCases) { ty in
                    if !criteria.contains(where: { $0.type == ty }) {
                        Button(ty.description) {
                            add(criterion: ApplicationSortOption(type: ty, direction: .ascending))
                        }
                    }
                }
                
                Divider()
                
                if !self.criteria.isEmpty {
                    Button {
                        self.removeAll()
                    } label: {
                        Label("Remove All", systemImage: "multiply")
                    }
                }
            } label: {
                Label("Add filter", systemImage: "bag.fill")
            }
            .padding([.top], 10)
        }
    }
}

#Preview {
    ApplicationSortingOptionsView(criteria: .constant([
        ApplicationSortOption(type: .byCareer, direction: .ascending),
        ApplicationSortOption(type: .byCreationDate, direction: .descending),
        ApplicationSortOption(type: .byTitle, direction: .descending),
        ApplicationSortOption(type: .byLastUpdateDate, direction: .ascending)
    ]))
}
