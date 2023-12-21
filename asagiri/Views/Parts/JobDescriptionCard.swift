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
//  JobDescriptionCard.swift
//  asagiri
//
//  Created by irony on 01/12/2023.
//

import Foundation
import SwiftUI

struct JobDescriptionCard: View {
    
    @Binding var pathManager:PathManager
    
    @Environment(\.modelContext) private var modelContext
    
    let jd: JobDescription
    
    let completed: Bool
    
    @State var detailed: Bool = false
    
    init(jd: JobDescription, completed: Bool, pathManager: Binding<PathManager>) {
        self.jd = jd
        self.completed = completed
        self._pathManager = pathManager
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(jd.title)
                        .font(.headline)
                    Text(jd.organization?.name ?? "")
                        .font(.subheadline)
                }
                Spacer()
                Text(jd.type?.name ?? "")
            }
            .foregroundColor(completed ? .gray : .black)
            HStack(alignment: .bottom) {
                if (jd.intro.count > 0) {
                    Text("\(jd.intro.prefix(136).description) ...")
                        .foregroundColor(completed ? .gray : .black)
                }
                Spacer()
                
                if !completed {
                    NavigationLink(value: jd, label: {
                        Text("Finish")
                            .foregroundColor(.blue)
                    })
                }
                
            }
        }
        Divider()
            .padding([.bottom], 12)
    }
}

