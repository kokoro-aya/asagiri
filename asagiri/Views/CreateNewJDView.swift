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

struct CreateNewJDView: View {
    
    @State private var displayMenuBar: Bool = false
    
    @Binding var pathManager:PathManager
    
    init(pathManager: Binding<PathManager>, pendingJD: JobDescription) {
        self._pathManager = pathManager
        self.title = pendingJD.title
        self.company = pendingJD.company
        self.type = pendingJD.type
        self.intro = pendingJD.intro
        self.companyIntro = pendingJD.companyIntro
        self.responsibilities = pendingJD.responsibilities
        self.complementary = pendingJD.complementary
        
    }
    
    init(pathManager: Binding<PathManager>) {
        self._pathManager = pathManager
    }
    
    
    @Query let allJobTypes: [CareerType]
    
    @Query let allCompanies: [Company]
    
    @State var expanded: (Bool, Bool, Bool, Bool) = (true, false, false, false)
    
    @State var title: String = ""
    
    @State var type: CareerType? = nil
    
    @State var intro: String = ""
    
    @State var companyIntro: String = ""
    
    @State var responsibilities: String = ""
    
    @State var complementary: String = ""
    
    @State var company: Company? = nil
    
    var incomplete: Bool {
        return title.count > 0
            && company != nil
            && type != nil
    }
    
    var body: some View {
        NavigationStack {
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
                                Text("Company")
                                    .font(.title3)
                            }
                            Spacer()
                            
                            CompanyDropdownSelector(allCompanies: allCompanies, pathManager: $pathManager, company: $company)
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
                            CustomTextEditor(text: $intro, height: 60)
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
                            CustomTextEditor(text: $companyIntro, height: 60)
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
                            CustomTextEditor(text: $responsibilities, height: 60)
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
                            CustomTextEditor(text: $complementary, height: 60)
                        } else {
                            Spacer()
                                .frame(height: 16)
                        }
                    }
                }
                Divider()
                
                Button {
                    let generatedJD = JobDescription(
                        title: title,
                        company: nil,
                        type: nil,
                        intro: self.intro,
                        companyIntro: self.companyIntro,
                        responsibilities: self.responsibilities,
                        complementary: self.complementary)
                    
                    generatedJD.company = self.company
                    generatedJD.type = self.type
                    
                    pathManager.path.append(generatedJD)
                } label: {
                    Label("Save", systemImage: "paperplane.fill")
                        .padding(12)
                }
                .navigationDestination(for: JobDescription.self) { jd in
                    CreateNewApplicationView(pathManager: $pathManager, jobDescription: jd)
                        .navigationBarBackButtonHidden(true)
                }
                .disabled(!incomplete)
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
                        
                        //
                        
                        Label("Menu", systemImage: "house.fill")
                            .foregroundColor(.black)
                        
                        NavigationLink(destination: SettingsView(pathManager: $pathManager)
                            .navigationBarBackButtonHidden(true),
                           label: {
                            Label("Menu", systemImage: "gear")
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
                    NavigationLink(destination: ApplicationListView(pathManager: $pathManager)
                        .navigationBarBackButtonHidden(true),
                        label: {
                        Label("Go back", systemImage: "delete.backward")
                    })
                }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let companies = [
            Company(name: "Company 1", website: "com.1"),
            Company(name: "Company 2", website: "com.2"),
            Company(name: "Company 3", website: "com.3"),
            Company(name: "Company 4", website: "com.4"),
            Company(name: "Company 5", website: "com.5"),
        ]
        
        let allJobTypes = [
            CareerType(name: "Front-end"),
            CareerType(name: "Back-end"),
            CareerType(name: "Fullstack"),
        ]
        
        companies.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        allJobTypes.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        
        
        return CreateNewJDView(pathManager: .constant(PathManager()))
        .modelContainer(previewContainer)
    }
}


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
            NavigationLink(
                destination: CreateNewCompanyView(pathManager: $pathManager,
                                                  onCompletion: { newCo in self.company = newCo })
                .navigationBarBackButtonHidden(true)
            ) {
                Label("Add new one", systemImage: "plus")
            }
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

struct CustomTextEditor : View {
    
    @Binding var text: String
    
    let height: Int
    
    let placeholder: String = "Enter your description here ..."
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .frame(height: 160)
            if (text == "") {
                Text(placeholder).fontWeight(.light).foregroundColor(.black.opacity(0.25))
                    .padding(8)
                    .padding([.leading], 0)
                    .allowsHitTesting(false)
            }
        }
    }
}


struct CollapseToggle : View {
    
    @Binding var toggled: Bool
    
    let onPress: () -> ()
    
    var body: some View {
        Button (action: onPress) {
            if (toggled) {
                Image(systemName: "xmark")
            } else {
                Image(systemName: "plus")
            }
        }
        .foregroundColor(.black)
        .padding(8)
    }
}
