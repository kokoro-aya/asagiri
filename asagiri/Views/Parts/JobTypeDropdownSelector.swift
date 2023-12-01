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
//  JobTypeDropdownSelector.swift
//  asagiri
//
//  Created by irony on 01/12/2023.
//

import Foundation
import SwiftUI

struct JobTypeDropdownSelector : View {
    
    let allJobTypes: [CareerType]
    
    @Binding var jobType: CareerType?
    
    
    var body: some View {
        Menu {
            ForEach(allJobTypes) { ty in
                Button(ty.name) {
                    self.jobType = ty
                }
            }
            Divider()
            Button(role: .destructive) {
                self.jobType = nil
            } label: {
                Label("Remove", systemImage: "trash")
            }
        } label: {
            Label(jobType?.name ?? "Job Type", systemImage: "bag.fill")
                .foregroundColor(jobType == nil ? .blue : .black)
        }
    }
}
