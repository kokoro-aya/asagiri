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
//  JDListView.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import SwiftUI
import SwiftData

#if os(iOS)
struct JDListView: View {
    
    @Binding var pathManager:PathManager
    
    @Query private var jobDescriptions: [JobDescription]
    
    @Query private var existingApps: [Application]
    
    @State private var showFinished: Bool = false
    
    var finishedJDs: [JobDescription] {
        return jobDescriptions.filter { jd in existingApps.contains(where: { $0.jobDescription == jd }) }
    }
    
    var unfinishedJDs: [JobDescription] {
        return jobDescriptions.filter { !finishedJDs.contains($0) }
    }
    
    @State private var displayMenuBar: Bool = false
    
    var body: some View {
        ScrollView {
            ForEach(unfinishedJDs) { jd in
                JobDescriptionCard(jd: jd, completed: false, pathManager: $pathManager)
                    .padding([.leading, .trailing], 10)
            }
            if showFinished {
                Button {
                    showFinished = false
                } label: {
                    Label("Hide", systemImage: "minus")
                }
                ForEach(finishedJDs) { jd in
                    JobDescriptionCard(jd: jd, completed: true, pathManager: $pathManager)
                        .padding([.leading, .trailing], 10)
                }
            } else {
                Button {
                    showFinished = true
                } label: {
                    Label("Show completed JDs", systemImage: "plus")
                }
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
                    
                    NavigationLink(value: PageType.home, label: {
                        Label("Home", systemImage: "house.fill")
                    })
                    
                    Label("JD List", systemImage: "bag.fill")
                        .foregroundColor(.black)
                        .padding([.leading, .trailing], 10)
                    
                    NavigationLink(value: PageType.settings, label: {
                        Label("Settings", systemImage: "gear")
                    })
                    
                    NavigationLink(value: PageType.analytics, label: {
                        Label("Analytics", systemImage: "chart.pie")
                    })

                    
                }
            } else {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        displayMenuBar = true
                    } label: {
                        Label("Menu", systemImage: "line.3.horizontal")
                    }
                    
                    Text("Job Descriptions")
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
        // Prevent the view from being pushed down
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}


#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let jd0 = JobDescription(title: "technical writer", organization: Organization(name: "Company 0", website: "company0.com"), type: CareerType(name: "Writer"), intro: "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?", orgIntro: "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.", responsibilities: "Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus.", complementary: "Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.")
        let jd1 = JobDescription(title: "front-end developer", organization: Organization(name: "Company 1", website: "company1.com"), type: CareerType(name: "Front-end"))
        let jd2 = JobDescription(title: "backend developer", organization: Organization(name: "Company 2", website: "company2.com"), type: CareerType(name: "Back-end"))
        let jd3 = JobDescription(title: "devops", organization: Organization(name: "Company 3", website: "company3.com"), type: CareerType(name: "Devops"))
        let jd4 = JobDescription(title: "fullstack", organization: Organization(name: "Company 4", website: "company4.com"), type: CareerType(name: "Fullstack"))
        
        let jds = [jd0, jd1, jd2, jd3, jd4]
        
        let app1 = Application(jobDescription: jd0, resume: Resume(content: "resume 1"), cover: CoverLetter(content: "cover 1"), dateCreated: .now, events: [])
        let app2 = Application(jobDescription: jd4, resume: Resume(content: "resume 2"), cover: CoverLetter(content: "cover 2"), dateCreated: .now, events: [])
        
        let apps = [app1, app2]
        
        jds.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        apps.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return JDListView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}
#endif
