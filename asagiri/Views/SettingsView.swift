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
//  SettingsView.swift
//  asagiri
//
//  Created by irony on 27/11/2023.
//

import SwiftUI

struct SettingsView: View {

    @Binding var pathManager:PathManager

    @State private var displayMenuBar: Bool = false    
    
    var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    NavigationLink(value: PageType.career_manage, label: {
                        Text("Manage careers")
                    })
                    
                    Spacer()
                        .frame(height: 16)
                    
                    NavigationLink(value: PageType.tag_manage, label: {
                        Text("Manage tags")
                    })
                    
                    Spacer()
                        .frame(height: 16)
                    
                    NavigationLink(value: PageType.company_list, label: {
                        Text("Show companies")
                    })
                    
                    Spacer()
                        .frame(height: 16)
                    
                    NavigationLink(value: PageType.export_import, label: {
                        Text("Export/Import")
                    })
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
                        
                        NavigationLink(value: PageType.jd_list, label: {
                            Label("JD List", systemImage: "bag.fill")
                        })
                        
                        Label("Settings", systemImage: "gear")
                            .foregroundColor(.black)
                            .padding([.leading, .trailing], 10)
                        
                        NavigationLink(value: PageType.analytics, label: {
                            Label("Analytics", systemImage: "chart.pie")
                        })

                    }
                } else {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            displayMenuBar = true
                        } label: {
                            Label("Menu", systemImage: "line.3.horizontal")
                        }
                        
                        Text("Settings")
                            .font(.title2)
                    }
                }
            }
        }
    }

#Preview {
    SettingsView(pathManager: .constant(PathManager()))
}
