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
//  OrganizationListView.swift
//  asagiri
//
//  Created by irony on 02/12/2023.
//

import SwiftUI
import SwiftData

struct OrganizationListView: View {
    
    @State private var displayMenuBar = false
    
    @Binding var pathManager:PathManager
    
    @Query private var organizations: [Organization]
    
    var body: some View {
        VStack {
            List {
                ForEach(organizations) { org in
                    VStack(alignment: .leading) {
                        Text(org.name)
                        if org.website.count > 0 {
                            Text(org.website)
                                .font(.caption)
                        }
                    }
                }
            }
    //                .scrollContentBackground(.hidden)
            Spacer()
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
                    
                }
            } else {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    Button {
                        displayMenuBar = true
                    } label: {
                        Label("Menu", systemImage: "line.3.horizontal")
                    }
                    
                    Text("Manage Tags")
                        .font(.title2)
                }
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        var previewContainer: ModelContainer = initializePreviewContainer()
        
        let organizations = [
            Organization(name: "New Co", website: ""),
            Organization(name: "Cat Inc", website: "https://www.cat.org")
        ]
        
        organizations.forEach {
            previewContainer.mainContext.insert($0)
        }
        
        return OrganizationListView(pathManager: .constant(PathManager()))
            .modelContainer(previewContainer)
    }
}
