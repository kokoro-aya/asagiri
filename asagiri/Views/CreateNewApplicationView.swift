//
//  CreateNewApplicationView.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import SwiftUI
import SwiftData

struct CreateNewApplicationView: View {
    
    @State private var displayMenuBar: Bool = false
    
    @EnvironmentObject var pathManager:PathManager
    
    @Environment(\.modelContext) private var modelContext
    
    let jobDescription: JobDescription
    
    @State var filled: (Bool, Bool) = (false, false)
    
    @State var resume: String = ""
    
    @State var resumeComment: String = ""

    @State var cover: String = ""
    
    var body: some View {
            VStack {
                HStack {
                    Text(jobDescription.company.name)
                        .font(.title3)
                        .foregroundStyle(.gray)
                    Spacer()
                    Text(jobDescription.company.website)
                        .font(.title3)
                        .foregroundStyle(.gray)
                }
                .padding([.top, .bottom], 8)
                ScrollView {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Position")
                                .font(.title3)
                            Spacer()
                            Text(jobDescription.title)
                                .font(.title3)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Resume")
                                .font(.title3)
                            Spacer()
                            CollapseToggle(toggled: $filled.0) {
                                filled.0 = !(filled.0)
                            }
                        }
                        if (filled.0) {
                            CustomTextEditor(text: $resume, height: 60)
                            Text("Comment")
                                .font(.title3)
                            CustomTextEditor(text: $resumeComment, height: 20)
                        } else {
                            Spacer()
                                .frame(height: 16)
                        }
                        Divider()
                        HStack {
                            Text("Cover")
                                .font(.title3)
                            Spacer()
                            CollapseToggle(toggled: $filled.1) {
                                filled.1 = !(filled.1)
                            }
                        }
                        if (filled.1) {
                            CustomTextEditor(text: $cover, height: 60)
                        } else {
                            Spacer()
                                .frame(height: 16)
                        }
                    }
                    Spacer()
                }
                Divider()
                Button {
                    //                NavigationLink(destination: <#T##() -> View#>, label: <#T##() -> View#>)
                    
                    modelContext.insert(jobDescription)
                    
                    let createdApplication = Application()
                    
                    modelContext.insert(createdApplication)
                    
                    createdApplication.jobDescription = jobDescription
                    createdApplication.resume = Resume(content: resume)
                    createdApplication.cover = CoverLetter(content: cover)
                    createdApplication.events.append(Event(type: .preparation))
                    
                    pathManager.path.append("applications")
                    
                } label: {
                    Label("Save", systemImage: "paperplane.fill")
                        .padding(12)
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
                        
                        //
                        
                        Label("Menu", systemImage: "house.fill")
                            .foregroundColor(.black)
                        
                        Button {
                            
                        } label: {
                            Label("Menu", systemImage: "gear")
                        }
                    }
                } else {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            displayMenuBar = true
                        } label: {
                            Label("Menu", systemImage: "line.3.horizontal")
                        }
                        
                        Text("Create an application")
                            .font(.title2)
                    }
                }
                ToolbarItem {
    //                    EditButton()
                    Button {
                        pathManager.path.removeLast()
                    } label: {
                        Label("Go back", systemImage: "arrowshape.turn.up.backward")
                    }
                }
            }
        }
    }

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let jd = JobDescription(title: "junior DevOps", company: Company(name: "newco", website: "https://new.co"), type: CareerType(name: "Hello Inc"))
        
        // Make sure to also push the dummy data sample into container otherwise preview will crash
        // as the `.company` relationship is accessed
        previewContainer.mainContext.insert(jd)
        
        return CreateNewApplicationView(jobDescription: jd)
            .modelContainer(previewContainer)
    }
}
