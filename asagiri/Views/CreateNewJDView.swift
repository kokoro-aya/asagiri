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
    
    let allJobTypes: [CareerType]
    
    @State var expanded: (Bool, Bool, Bool, Bool) = (true, false, false, false)
    
    @State var title: String = ""
    
    @State var type: CareerType? = nil
    
    @State var intro: String = ""
    
    @State var companyIntro: String = ""
    
    @State var responsibilities: String = ""
    
    @State var complementary: String = ""
    
    var company: Company? = nil
    
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
        }.padding(16)
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
            Label("Switch Type", systemImage: "ellipsis.circle")
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
