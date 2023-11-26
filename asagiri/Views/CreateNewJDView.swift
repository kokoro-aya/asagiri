//
//  CreateNewJDView.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI
import SwiftData

struct CreateNewJDView: View {
    
    init(pendingJD: JobDescription, allJobTypes: [CareerType], allCompanies: [Company]) {
        self.title = pendingJD.title
        self.company = pendingJD.company
        self.type = pendingJD.type
        self.intro = pendingJD.intro
        self.companyIntro = pendingJD.companyIntro
        self.responsibilities = pendingJD.responsibilities
        self.complementary = pendingJD.complementary
        
        self.allJobTypes = allJobTypes
        self.allCompanies = allCompanies
    }
    
    init(allJobTypes: [CareerType], allCompanies: [Company]) {
        self.allJobTypes = allJobTypes
        self.allCompanies = allCompanies
    }
    
    let allJobTypes: [CareerType]
    
    let allCompanies: [Company]
    
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
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Create a new job description")
                    .font(.caption)
                Spacer()
            }
            Divider()
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
                        
                        CompanyDropdownSelector(allCompanies: allCompanies, company: $company)
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
                //                NavigationLink(destination: <#T##() -> View#>, label: <#T##() -> View#>)
            } label: {
                Label("Save", systemImage: "paperplane.fill")
                    .padding(12)
            }
            .disabled(!incomplete)
        }.padding(16)
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
        
        return CreateNewJDView(
            allJobTypes: [
                CareerType(name: "Front-end"),
                CareerType(name: "Back-end"),
                CareerType(name: "Fullstack"),
            ],
            allCompanies: companies
        )
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
                Label("Delete", systemImage: "trash")
            }
        } label: {
            Label(jobType?.name ?? "Job Type", systemImage: "bag.fill")
                .foregroundColor(jobType == nil ? .blue : .black)
        }
    }
}

struct CompanyDropdownSelector : View {
    
    let allCompanies: [Company]
    
    @Binding var company: Company?
    
    
    var body: some View {
        Menu {
            ForEach(allCompanies) { com in
                Button(com.name) {
                    self.company = com
                }
            }
            Divider()
            NavigationLink(destination: CreateNewCompanyView()) {
                Label("Create new one", systemImage: "plus")
            }
            Button(role: .destructive) {
                self.company = nil
            } label: {
                Label("Delete", systemImage: "trash")
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
                Image(systemName: "minus")
            } else {
                Image(systemName: "plus")
            }
        }
        .foregroundColor(.black)
        .padding(8)
    }
}
