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
//  CreateNewCompanyView.swift
//  asagiri
//
//  Created by irony on 24/11/2023.
//

import SwiftUI
import SwiftData

struct CreateNewCompanyView: View {
    
    @State private var displayMenuBar: Bool = false
    
    @Binding var pathManager:PathManager
    
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var name: String = ""
    
    @State var website: String = ""
    
    var onCompletion: (_ company: Company) -> ()
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Name")
                        .font(.title3)
                    Spacer()
                }
                TextField("Company name", text: $name)
                    .padding([.leading], 6)
                HStack {
                    Text("Website")
                        .font(.title3)
                    Spacer()
                }
                TextField("Website", text: $website)
                    .padding([.leading], 6)
            }
            Spacer()
            Divider()
            Button {
                let company = Company(name: name, website: website)
                onCompletion(company)
                presentationMode.wrappedValue.dismiss()
                
            } label: {
                Label("Save", systemImage: "paperplane.fill")
                    .padding(12)
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
                    
                    
                    NavigationLink(value: PageType.home, label: {
                        Label("Home", systemImage: "house.fill")
                    })
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
                    
                    Text("Add a new company")
                        .font(.title2)
                }
            }
            ToolbarItem {
                Button {
                    presentationMode.wrappedValue.dismiss()
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
        
        return CreateNewCompanyView(pathManager: .constant(PathManager()), onCompletion: { _ in })
            .modelContainer(previewContainer)
    }
}
