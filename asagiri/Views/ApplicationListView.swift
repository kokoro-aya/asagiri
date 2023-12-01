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
//  ApplicationListView.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import SwiftUI
import SwiftData

struct ApplicationListView: View {
    
    @Binding var pathManager:PathManager
    
    @Query private var applications: [Application]
    
    @State private var displayMenuBar: Bool = false
    
    // TODO: Add filter facilities
    
    var body: some View {
            ScrollView {
                ForEach(applications) { app in
                    ApplicationCard(application: app)
                        .padding([.leading, .trailing], 10)
                }
            }
            .padding([.top], 12)
            .padding(8)
            .toolbar {
                if displayMenuBar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            displayMenuBar = false
                        } label: {
                            Label("Menu", systemImage: "arrow.left")
                        }
                        
                        //
                        
                        Label("Menu", systemImage: "house.fill")
                            .foregroundColor(.black)
                        
                        NavigationLink(value: PageType.settings, label: {
                            Label("Settings", systemImage: "gear")
                        })
                        
                    }
                } else {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            displayMenuBar = true
                        } label: {
                            Label("Menu", systemImage: "line.3.horizontal")
                        }
                        
                        Text("Applications")
                            .font(.title2)
                    }
                }
                ToolbarItem {
//                    EditButton()
                    NavigationLink(value: PageType.create_new_jd, label: {
                        Label("Add Item", systemImage: "square.and.pencil")
                    })
                    
                }
            }
        }
    }

func createDateFromString(_ s: String) -> Date {
    let RFC3339DateFormatter = DateFormatter()
    RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
    RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    return RFC3339DateFormatter.date(from: s)!
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let app0 = Application(jobDescription: JobDescription(title: "technical writer", company: Company(name: "Company 0", website: "company.com"), type: CareerType(name: "Writer")),
               dateCreated: createDateFromString("2023-08-22T16:19:25-08:00"))
        
        let app1 = Application(jobDescription: JobDescription(title: "junior DevOps", company: Company(name: "Company 1", website: "company.com"), type: CareerType(name: "DevOps")),
               dateCreated: createDateFromString("2023-09-12T17:59:13-08:00"),
               events: [
                Event(type: .applied, updateTime:  createDateFromString("2023-09-12T17:59:13-08:00"))
               ])
        
        let app2 = Application(jobDescription: JobDescription(title: "Fullstack developer", company: Company(name: "Company 2", website: "company.com"), type: CareerType(name: "Fullstack")), 
               dateCreated: createDateFromString("2023-09-19T12:56:47-08:00"),
               events: [
                Event(type: .applied, updateTime:  createDateFromString("2023-09-19T12:56:47-08:00")),
                Event(type: .phone_screen, updateTime:  createDateFromString("2023-10-03T10:15:23-08:00"))
               ])
        
        let app3 = Application(jobDescription: JobDescription(title: "Front-end developer", company: Company(name: "Company 3", website: "company.com"), type: CareerType(name: "Front-end")),
               resume: Resume(content: "An MBA with 5 years of experience developing and managing marketing campaigns and specialized working knowledge of Google Analytics and AdWords, seeks the role of Social Media Marketing Manager with XYZ Inc. to implement successful digital marketing campaigns and provide exceptional thought leadership."),
               dateCreated: createDateFromString("2023-10-05T17:59:23-08:00"),
               events: [
                Event(type: .applied, updateTime:  createDateFromString("2023-10-05T17:59:23-08:00")),
                Event(type: .rejected, updateTime:  createDateFromString("2023-10-10T12:13:14-08:00"))
               ])
        
        let app4 = Application(jobDescription: JobDescription(title: "Backend developer", company: Company(name: "Company 1", website: "company.com"), type: CareerType(name: "Back-end")),
               resume: Resume(content: "PROFESSIONAL WRITER\nA talented and versatile writer, proficient in all aspects of technical communications\nRespected professional writer with 10+ years of experience who has generated hundreds of business materials, including reports, letters, proposals, presentations, press releases, reviews, and manuals."),
               cover: CoverLetter(content: "Dear Mr. Jacobson,\nAs a long-term admirer of the impressive work being done by the team at Mayflower Technologies, I’m delighted to submit my application for the entry-level IT technician position posted on Indeed.com. As a recent graduate from the University of Rochester with a B.S. in Computer Science, I’m confident that my knowledge of Linux systems, experience in backend coding, and precise attention to detail would make me an asset to the team at Mayflower."),
               dateCreated: createDateFromString("2023-10-11T12:59:16-08:00"),
               events: [
                Event(type: .applied, updateTime:  createDateFromString("2023-10-11T12:59:16-08:00")),
                Event(type: .interview(round: 1), updateTime:  createDateFromString("2023-10-13T14:16:15-08:00")),
                Event(type: .interview(round: 2), updateTime:  createDateFromString("2023-10-16T07:11:34-08:00")),
                Event(type: .interview(round: 3), updateTime:  createDateFromString("2023-10-23T19:22:57-08:00")),
                Event(type: .interview(round: 4), updateTime:  createDateFromString("2023-11-10T20:15:25-08:00")),
                Event(type: .interview(round: 5), updateTime:  createDateFromString("2023-12-19T18:02:13-08:00"))
               ])
        
        let app5 = Application(jobDescription: JobDescription(title: "UI Designer", company: Company(name: "Company 3", website: "company.com"), type: CareerType(name: "UI")),
               cover: CoverLetter(content: "In my former role as a student worker at the University of Rochester’s Technical Services department, I was responsible for troubleshooting a variety of technical issues for staff, assisting with server maintenance, and installing a wide range of equipment. While employed there, I assisted in the development and rollout of new department practices, and helped improve our ticket response time by 12%. I’m sure that this experience will help me hit the ground running at Mayflower."),
               dateCreated: createDateFromString("2023-10-12T17:52:10-08:00"),
               events: [
                Event(type: .applied, updateTime:  createDateFromString("2023-10-12T17:52:10-08:00")),
                Event(type: .interview(round: 1), updateTime:  createDateFromString("2023-10-15T10:52:10-08:00"))
               ])
        
        let apps = [app0, app1, app2, app3, app4, app5]
        
        apps.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        
        return ApplicationListView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}
