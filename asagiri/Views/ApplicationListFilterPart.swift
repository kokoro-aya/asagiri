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
//  ApplicationListFilterPart.swift
//  asagiri
//
//  Created by irony on 16/12/2023.
//

import SwiftUI
import WrappingHStack

struct ApplicationSortingOptionsView: View {

    @Binding var criteria: [ApplicationSortOption]
    
    func add(criterion: ApplicationSortOption) {
        if !criteria.contains(criterion) {
            criteria.append(criterion)
        }
    }
    
    func remove(criterion: ApplicationSortOption) {
        if let pos = criteria.firstIndex(of: criterion) {
            criteria.remove(at: pos)
        }
    }
    
    func removeAll() {
        criteria.removeAll()
    }
    
    var body: some View {
        HStack(alignment: .top) {
            WrappingHStack(criteria) { crit in
                TagChip(text: crit.description, onDelete: {_ in
                    remove(criterion: crit)
                })
                .padding([.top, .bottom], 4)
            }
            Spacer()
            Menu {
                ForEach(ApplicationSortOption.allCases) { crit in
                    if !criteria.contains(crit) {
                        Button(crit.description) {
                            add(criterion: crit)
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
    ApplicationSortingOptionsView(criteria: .constant([.byCareer, .byCreationDate, .byTitle, .byLastUpdateDate]))
}
