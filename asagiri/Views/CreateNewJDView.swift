//
//  CreateNewJDView.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI
import SwiftData

struct CreateNewJDView: View {
    
    init(pendingJD: JobDescription, allJobTypes: [CareerType]) {
        self.title = pendingJD.title
        self.company = pendingJD.company
        self.type = pendingJD.type
        self.intro = pendingJD.intro
        self.companyIntro = pendingJD.companyIntro
        self.responsibilities = pendingJD.responsibilities
        self.complementary = pendingJD.complementary
        
        self.allJobTypes = allJobTypes
    }
    
    init(allJobTypes: [CareerType]) {
        self.allJobTypes = allJobTypes
    }
    
    @State var title: String = ""
    
    var company: Company? = nil
    
    @State var type: CareerType? = nil
    
    let allJobTypes: [CareerType]
    
    @State var intro: String = ""
    
    @State var companyIntro: String = ""
    
    @State var responsibilities: String = ""
    
    @State var complementary: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Text("Job title")
                        .font(.subheadline)
                    TextField("Title", text: $title)
                }
                Spacer()
            
                JobTypeDropdownSelector(allJobTypes: allJobTypes, jobType: $type)
            }
            Text("Type: \(type?.name ?? "No Type")")
            Text("Job title")
                .font(.subheadline)
            TextField("Title", text: $title)
            Text("Job title")
                .font(.subheadline)
            TextField("Title", text: $title)
            Text("Job title")
                .font(.subheadline)
            TextField("Title", text: $title)
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        
        return CreateNewJDView(
            allJobTypes: [
                CareerType(name: "Front-end"),
                CareerType(name: "Back-end"),
                CareerType(name: "Fullstack"),
            ]
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
            Label("Jobs", systemImage: "ellipsis.circle")
        }
    }
}
