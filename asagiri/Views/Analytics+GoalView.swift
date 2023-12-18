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
//  Analytics+GoalView.swift
//  asagiri
//
//  Created by irony on 18/12/2023.
//

import SwiftUI
import SwiftData

struct Analytics_GoalView: View {
    
    @Query var applications: [Application]
    
    var monthStarts: Date {
        let month = Calendar.current.dateComponents([.year, .month], from: .now)
        return Calendar.current.date(from: month)!
    }
    
    var appliedThisMonth: Int {
        return applications.filter { $0.dateCreated >= monthStarts }.count
    }
    
    var goal: Int {
        if appliedThisMonth < 30 {
            return 30
        } else if appliedThisMonth < 60 {
            return 60
        } else if appliedThisMonth < 90 {
            return 90
        } else {
            return appliedThisMonth
        }
    }
    
    func dateRange() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let begins = formatter.string(from: monthStarts)
        let curr = formatter.string(from: .now)
        return "\(begins) - \(curr)"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("This month")
                .font(.title3)
            Text(dateRange())
                .font(.subheadline)
            HStack {
                Text("\(appliedThisMonth)/\(goal)")
                    .foregroundStyle(.blue)
                    .font(.title)
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                        .foregroundColor(.teal)
                        .opacity(0.5)
                        .frame(width: 180, height: 10)
                
                    RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                        .foregroundColor(.green)
                        .frame(width: CGFloat((Float(appliedThisMonth) / Float(goal))) * 180, height: 10)
                }
            }
            .padding([.top, .bottom], 8)
            if goal > appliedThisMonth {
                Text("Try to achieve \(goal) applications for this month!")
            } else {
                Text("Well done!")
            }
        }
        .padding(16)
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
        
        return Analytics_GoalView()
            .modelContainer(previewContainer)
        
    }
}
