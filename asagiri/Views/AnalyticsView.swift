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
//  AnalyticsView.swift
//  asagiri
//
//  Created by irony on 04/12/2023.
//

import SwiftUI
import SwiftData

struct AnalyticsView: View {

    @Binding var pathManager:PathManager
    
    @Query var applications: [Application]

    @State private var displayMenuBar: Bool = false
    
    var body: some View {
        VStack {
            if applications.count < 5 {
                Text("Add more applications to preview you stats")
            } else {
                ChartWindowView(applications: applications)
            }
        }
        .padding([.top], 20)
        .padding(16)
        .toolbar {
            if displayMenuBar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        displayMenuBar = false
                    } label: {
                        Label("Menu", systemImage: "arrow.left")
                    }
                    
                    NavigationLink(value: PageType.home, label: {
                        Label("Home", systemImage: "house.fill")
                    })
                    
                    NavigationLink(value: PageType.jd_list, label: {
                        Label("JD List", systemImage: "bag.fill")
                    })
                    
                    NavigationLink(value: PageType.settings, label: {
                        Label("Settings", systemImage: "gear")
                    })
                    
                    Label("Analytics", systemImage: "chart.pie")
                        .foregroundColor(.black)
                        .padding([.leading], 10)
                }
            } else {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        displayMenuBar = true
                    } label: {
                        Label("Menu", systemImage: "line.3.horizontal")
                    }
                    
                    Text("Analytics")
                        .font(.title2)
                }
            }
        }
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
        
        return AnalyticsView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}
