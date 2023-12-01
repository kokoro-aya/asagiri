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
//  CreateNewApplicationView.swift
//  asagiri
//
//  Created by irony on 23/11/2023.
//

import SwiftUI
import SwiftData

struct CreateNewApplicationView: View {
    
    @State private var displayMenuBar: Bool = false
    
    @Binding var pathManager:PathManager
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.presentationMode) var presentationMode
    
    let jobDescription: JobDescription
    
    @State var filled: (Bool, Bool) = (false, false)
    
    @State var resume: String = ""
    
    @State var resumeComment: String = ""
    
    @State var cover: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Text(jobDescription.company?.name ?? "")
                    .font(.title3)
                    .foregroundStyle(.gray)
                Spacer()
                Text(jobDescription.company?.website ?? "")
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
            HStack {
                Button {
                    modelContext.insert(jobDescription)
                    
                    let createdApplication = Application()
                    
                    modelContext.insert(createdApplication)
                    
                    createdApplication.jobDescription = jobDescription
                    createdApplication.resume = Resume(content: resume)
                    createdApplication.cover = CoverLetter(content: cover)
                    createdApplication.events.append(Event(type: .preparation))
                    
                    pathManager.path.removeLast()
                    
                } label: {
                    Label("Save", systemImage: "paperplane.fill")
                        .padding(12)
                }
                Button {
                    
                    // Dummy CRUD for triggering page transition otherwise `removeLast` will remove nothing.
                    
                    // See: https://www.v2ex.com/t/996395
                    
                    let item = Item(timestamp: .now)
                    modelContext.insert(item)
                    modelContext.delete(item)
                    
                    pathManager.path.removeLast()
                    
                } label: {
                    Label("Discard", systemImage: "minus")
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
                        
                        NavigationLink(value: PageType.home, label: {
                            Label("Home", systemImage: "house.fill")
                        })
                        NavigationLink(value: PageType.settings, label: {
                            Label("Settings", systemImage: "gear")
                        })
                        
//                        NavigationLink(destination: ApplicationListView(pathManager: $pathManager)
//                            .navigationBarBackButtonHidden(true), label: {
//                            Label("Home", systemImage: "house.fill")
//                        })
//                        
//                        NavigationLink(destination: SettingsView(pathManager: $pathManager)
//                            .navigationBarBackButtonHidden(true),
//                           label: {
//                            Label("Menu", systemImage: "gear")
//                        })
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
            }
        }.padding(12)
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let jd = JobDescription(title: "junior DevOps", company: Company(name: "newco", website: "https://new.co"), type: CareerType(name: "Hello Inc"))
        
        // Make sure to also push the dummy data sample into container otherwise preview will crash
        // as the `.company` relationship is accessed
        previewContainer.mainContext.insert(jd)
        
        return CreateNewApplicationView(pathManager: .constant(PathManager()), jobDescription: jd)
            .modelContainer(previewContainer)
    }
}
