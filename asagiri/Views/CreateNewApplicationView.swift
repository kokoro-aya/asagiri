//
//  CreateNewApplicationView.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import SwiftUI
import SwiftData

struct CreateNewApplicationView: View {
    
    let jobDescription: JobDescription
    
    @State var filled: (Bool, Bool) = (false, false)
    
    @State var resume: String = ""
    
    @State var resumeComment: String = ""

    @State var cover: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("Create a new application")
                    .font(.caption)
                Spacer()
            }
            Divider()
            VStack(alignment: .leading) {
                HStack {
                    Text("Name")
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
                    CollapseToggle(toggled: $filled.1) {
                        filled.1 = !(filled.1)
                    }
                }
                if (filled.1) {
                    CustomTextEditor(text: $resume, height: 60)
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
        
        let jd = JobDescription(title: "junior DevOps", company: Company(name: "newco", website: "https://new.co"), type: CareerType(name: "Hello Inc"))
        
        return CreateNewApplicationView(jobDescription: jd)
            .modelContainer(previewContainer)
    }
}
