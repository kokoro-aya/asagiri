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
//  ApplicationPreviewView.swift
//  asagiri
//
//  Created by irony on 02/12/2023.
//

import SwiftUI
import SwiftData

struct ApplicationPreviewView: View {
    
    @State private var displayMenuBar: Bool = false
    
    @State var expanded: (Bool, Bool, Bool, Bool, Bool, Bool, Bool) = (false, false, false, false, true, false, false)
    
    @Binding var pathManager:PathManager
    
    var app: Application
    
    
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text(app.jobDescription?.title ?? "")
                            .font(.title3)
                        Spacer()
                        
                        Text(app.jobDescription?.type?.name ?? "")
                            .font(.title3)
                    }
                    .padding([.bottom], 8)
                        
                    Text(app.jobDescription?.company?.name ?? "")
                        .font(.title3)
                    
                    Divider()
                    
                    HStack {
                        let possibleNexts = self.app.status.possibleNexts()
                        
                        Menu {
                            
                            ForEach(possibleNexts) { sts in
                                Button(sts.description) {
                                    self.app.events.append(Event(type: sts))
                                }
                            }
                        } label: {
                            Text(app.status.description)
                                .font(.title3)
                                .foregroundStyle(possibleNexts.isEmpty ? Color.gray : Color.blue)
                        }
                        Spacer()
                        CollapseToggle(toggled: $expanded.6) {
                            expanded.6 = !(expanded.6)
                        }
                    }
                    if (expanded.6) {
                        ForEach(app.events.sorted(by: { $0.updateTime > $1.updateTime })) { event in
                            HStack {
                                Text(event.type.description)
                                Spacer()
                                Text(event.updateTime.formatted(.dateTime.day().month().year()))
                            }
                            .font(.footnote)
                        }
                        .padding([.leading, .trailing], 8)
                        .padding([.top, .bottom], 4)
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Resume")
                            .font(.title3)
                        Spacer()
                        CollapseToggle(toggled: $expanded.4) {
                            expanded.4 = !(expanded.4)
                        }
                    }
                    if (expanded.4) {
                        Text(app.resume?.content ?? "")
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                    Divider()
                    HStack {
                        Text("Cover Letter")
                            .font(.title3)
                        Spacer()
                        CollapseToggle(toggled: $expanded.5) {
                            expanded.5 = !(expanded.5)
                        }
                    }
                    if (expanded.5) {
                        Text(app.cover?.content ?? "")
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                
                    Divider()
                    
                    HStack {
                        Text("Introduction")
                            .font(.title3)
                        Spacer()
                        CollapseToggle(toggled: $expanded.0) {
                            expanded.0 = !(expanded.0)
                        }
                    }
                    if (expanded.0) {
                        Text(app.jobDescription?.intro ?? "")
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                    Divider()
                    HStack {
                        Text("Company Intro")
                            .font(.title3)
                        Spacer()
                        CollapseToggle(toggled: $expanded.1) {
                            expanded.1 = !(expanded.1)
                        }
                    }
                    if (expanded.1) {
                        Text(app.jobDescription?.companyIntro ?? "")
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                    Divider()
                    HStack {
                        Text("Responsibilities")
                            .font(.title3)
                        Spacer()
                        CollapseToggle(toggled: $expanded.2) {
                            expanded.2 = !(expanded.2)
                        }
                    }
                    if (expanded.2) {
                        Text(app.jobDescription?.responsibilities ?? "")
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                    Divider()
                    HStack {
                        Text("Complementary")
                            .font(.title3)
                        Spacer()
                        CollapseToggle(toggled: $expanded.3) {
                            expanded.3 = !(expanded.3)
                        }
                    }
                    if (expanded.3) {
                        Text(app.jobDescription?.complementary ?? "")
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                }
            }
            Spacer()
            Divider()
            Button(role: .destructive) {
                app.setArchived()
            } label: {
                Label("Archive", systemImage: "archivebox.fill")
            }
            .padding([.top], 16)
        }
        .padding(16)
        .toolbar {
            if displayMenuBar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        displayMenuBar = false
                    } label: {
                        Label("Menu", systemImage: "arrow.left")
                    }
                    
                    //
                    NavigationLink(value: PageType.home, label: {
                        Label("Home", systemImage: "house.fill")
                    })
                    
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
                    
                    Text("Application Preview")
                        .font(.title2)
                }
            }
            ToolbarItem {
//                    EditButton()
                
                NavigationLink(value: PageType.home, label: {
                    Label("Go back", systemImage: "delete.backward")
                })
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let app = Application(
            jobDescription: JobDescription(
                title: "Backend developer",
                company: Company(
                    name: "Company 1",
                    website: "company.com"),
                type: CareerType(name: "Back-end"),
                intro: "Some introduction\ngoes\nhere",
                companyIntro: "A simple introduction of the company",
                responsibilities: "Here are several leadership principles:\n1. xxx\n2. yyy\n3.zzz",
                complementary: "Nothing here yet"
            ),
            resume: Resume(
                content: "PROFESSIONAL WRITER\nA talented and versatile writer, proficient in all aspects of technical communications\nRespected professional writer with 10+ years of experience who has generated hundreds of business materials, including reports, letters, proposals, presentations, press releases, reviews, and manuals."),
            cover: CoverLetter(
                content: "Dear Mr. Jacobson,\nAs a long-term admirer of the impressive work being done by the team at Mayflower Technologies, I’m delighted to submit my application for the entry-level IT technician position posted on Indeed.com. As a recent graduate from the University of Rochester with a B.S. in Computer Science, I’m confident that my knowledge of Linux systems, experience in backend coding, and precise attention to detail would make me an asset to the team at Mayflower."),
            dateCreated: createDateFromString("2023-10-11T12:59:16-08:00"),
            events: [
                Event(type: .applied, updateTime:  createDateFromString("2023-10-11T12:59:16-08:00")),
                Event(type: .interview(round: 1), updateTime:  createDateFromString("2023-10-13T14:16:15-08:00")),
                Event(type: .interview(round: 2), updateTime:  createDateFromString("2023-10-16T07:11:34-08:00")),
                Event(type: .interview(round: 3), updateTime:  createDateFromString("2023-10-23T19:22:57-08:00")),
                Event(type: .interview(round: 4), updateTime:  createDateFromString("2023-11-10T20:15:25-08:00")),
                Event(type: .interview(round: 5), updateTime:  createDateFromString("2023-12-19T18:02:13-08:00"))
            ])
        
        previewContainer.mainContext.insert(app)
        
        return ApplicationPreviewView(pathManager: .constant(PathManager()), app: app)
            .modelContainer(previewContainer)
    }
    
    
}
