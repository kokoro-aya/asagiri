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
            Divider()
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
        
        // Make sure to also push the dummy data sample into container otherwise preview will crash
        // as the `.company` relationship is accessed
        previewContainer.mainContext.insert(jd)
        
        return CreateNewApplicationView(jobDescription: jd)
            .modelContainer(previewContainer)
    }
}
