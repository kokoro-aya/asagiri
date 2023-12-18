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
//  Analytics+TopView.swift
//  asagiri
//
//  Created by irony on 18/12/2023.
//

import SwiftUI
import SwiftData

struct Analytics_TopView: View {
    
    @Query var applications: [Application]
    
    var count: Int {
        applications.count
    }
    
    var appliedCount: Int {
        applications.filter { $0.status > .preparation }.count
    }
    
    var interviewCount: Int {
        applications
            .filter { $0.status >= .phoneScreen || $0.status >= .interview(round: 1) }
            .count
    }
    
    var body: some View {
        VStack {
            if applications.count < 5 {
                Text("Add more applications to preview you stats")
            } else {
                ChartWindowView(applications: applications)
                    .frame(height: 540)
            }
            HStack {
                Spacer()
                VStack {
                    Text("\(count)")
                        .font(.title)
                        .foregroundStyle(.gray)
                    Text("Apps")
                        .font(.footnote)
                }
                Spacer()
                VStack {
                    Text("\(appliedCount)")
                        .font(.title)
                        .foregroundStyle(.green)
                    Text("Applied")
                        .font(.footnote)
                }
                Spacer()
                VStack {
                    Text("\(interviewCount)")
                        .font(.title)
                        .foregroundStyle(.blue)
                    Text("Interviews")
                        .font(.footnote)
                }
                Spacer()
            }
            .padding([.top], -24)
        }
        .padding(8)
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let applications = [
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-12T12:00:00-08:00")),
                Event(type: .rejected, updateTime: createDateFromString("2023-10-13T14:50:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-11T12:00:00-08:00")),
                Event(type: .interview(round: 1), updateTime: createDateFromString("2023-10-12T21:00:00-08:00")),
                Event(type: .interview(round: 2), updateTime: createDateFromString("2023-10-16T15:20:00-08:00")),
                Event(type: .interview(round: 3), updateTime: createDateFromString("2023-10-19T14:00:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-17T12:00:00-08:00")),
                Event(type: .interview(round: 1), updateTime: createDateFromString("2023-10-18T14:30:00-08:00")),
                Event(type: .ghost, updateTime: createDateFromString("2023-10-22T14:20:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-22T13:50:00-08:00"))
            ]),
            Application(jobDescription: JobDescription(title: "A", organization: Organization(name: "B", website: "D"), type: CareerType(name: "C")), dateCreated: .now, events: [
                Event(type: .applied, updateTime: createDateFromString("2023-10-22T13:50:00-08:00")),
                Event(type: .oa, updateTime: createDateFromString("2023-11-15T13:00:00-08:00"))
            ])
        ]
        
        applications.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return Analytics_TopView()
            .modelContainer(previewContainer)
    }
}
