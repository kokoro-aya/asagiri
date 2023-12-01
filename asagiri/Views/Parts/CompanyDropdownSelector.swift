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
//  CompanyDropdownSelector.swift
//  asagiri
//
//  Created by irony on 01/12/2023.
//

import Foundation
import SwiftUI

struct CompanyDropdownSelector : View {
    
    let allCompanies: [Company]
    
    @Binding var pathManager: PathManager
    
    @Binding var company: Company?
    
    
    var body: some View {
        Menu {
            ForEach(allCompanies) { com in
                Button(com.name) {
                    self.company = com
                }
            }
            Divider()
            
            NavigationLink(value: NavigateToCompanyCreateArguments(onCompletion: { newCo in self.company = newCo }), label: {
                Label("Add new one", systemImage: "plus")
            })
            
            Button(role: .destructive) {
                self.company = nil
            } label: {
                Label("Remove", systemImage: "trash")
            }
        } label: {
            Label(company?.name ?? "Select one", systemImage: "building.2.fill")
                .foregroundColor(company == nil ? .blue : .black)
        }
    }
}
