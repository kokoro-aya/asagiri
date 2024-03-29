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
//  CreateNewJDView.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI
import SwiftData

#if os(iOS)
struct CreateNewJDView: View {
    
    @State private var displayMenuBar: Bool = false
    
    @Binding var pathManager:PathManager
    
    @Environment(\.modelContext) private var modelContext
    
    init(pathManager: Binding<PathManager>, pendingJD: JobDescription) {
        self._pathManager = pathManager
        self.title = pendingJD.title
        self.organization = pendingJD.organization
        self.type = pendingJD.type
        self.intro = pendingJD.intro
        self.orgIntro = pendingJD.orgIntro
        self.responsibilities = pendingJD.responsibilities
        self.complementary = pendingJD.complementary
        
    }
    
    init(pathManager: Binding<PathManager>) {
        self._pathManager = pathManager
    }
    
    
    @Query let allJobTypes: [CareerType]
    
    @Query let allOrganizations: [Organization]
    
    @State var expanded: (Bool, Bool, Bool, Bool) = (true, false, false, false)
    
    @State var title: String = ""
    
    @State var type: CareerType? = nil
    
    @State var intro: String = ""
    
    @State var orgIntro: String = ""
    
    @State var responsibilities: String = ""
    
    @State var complementary: String = ""
    
    @State var organization: Organization? = nil
    
    var incomplete: Bool {
        return title.count > 0
            && organization != nil
            && type != nil
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Job title")
                                .font(.title3)
                            TextField("Title", text: $title)
                                .padding([.leading], 6)
                        }
                        Spacer()
                        
                        JobTypeDropdownSelector(allJobTypes: allJobTypes, jobType: $type)
                    }
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Organization")
                                .font(.title3)
                        }
                        Spacer()
                        
                        OrganizationDropdownSelector(allOrganizations: allOrganizations, pathManager: $pathManager, organization: $organization)
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
                        CustomTextEditor(text: $intro, height: 160)
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                    Divider()
                    HStack {
                        Text("Org. Intro")
                            .font(.title3)
                        Spacer()
                        CollapseToggle(toggled: $expanded.1) {
                            expanded.1 = !(expanded.1)
                        }
                    }
                    if (expanded.1) {
                        CustomTextEditor(text: $orgIntro, height: 160)
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
                        CustomTextEditor(text: $responsibilities, height: 160)
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
                        CustomTextEditor(text: $complementary, height: 160)
                    } else {
                        Spacer()
                            .frame(height: 16)
                    }
                }
            }
            Divider()
            
            VStack {
                
                Button {
                    let generatedJD = JobDescription(
                        title: title,
                        organization: nil,
                        type: nil,
                        intro: self.intro,
                        orgIntro: self.orgIntro,
                        responsibilities: self.responsibilities,
                        complementary: self.complementary)
                    
                    generatedJD.organization = self.organization
                    generatedJD.type = self.type
                    
                    // Do not save JD but proceed it as an argument to the next page
                    pathManager.path.append(generatedJD)
                } label: {
                    Label("Continue to application", systemImage: "arrow.forward")
                        .padding(12)
                }
                .disabled(!incomplete)
                
                Button {
                    
                    let jobDescription = JobDescription(
                        title: title,
                        organization: nil,
                        type: nil,
                        intro: self.intro,
                        orgIntro: self.orgIntro,
                        responsibilities: self.responsibilities,
                        complementary: self.complementary)
                    
                    jobDescription.organization = self.organization
                    jobDescription.type = self.type
                    
                    // Save job description to the database
                    modelContext.insert(jobDescription)
                    
                    // Go back to main page
                    pathManager.path.append(PageType.home)
                } label: {
                    Label("Save and exit", systemImage: "arrow.down.doc")
                        .padding(12)
                }
                .disabled(!incomplete)
            }
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
                    
                    Text("Create a job description")
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
        
        let orgs = [
            Organization(name: "Company 1", website: "com.1"),
            Organization(name: "Company 2", website: "com.2"),
            Organization(name: "Company 3", website: "com.3"),
            Organization(name: "Company 4", website: "com.4"),
            Organization(name: "Company 5", website: "com.5"),
        ]
        
        let allJobTypes = [
            CareerType(name: "Front-end"),
            CareerType(name: "Back-end"),
            CareerType(name: "Fullstack"),
        ]
        
        orgs.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        allJobTypes.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return CreateNewJDView(pathManager: .constant(PathManager()))
        .modelContainer(previewContainer)
    }
}
#endif
